const LiveDoubtSession = require('../models/liveDoubtSession.model');

// ZEGOCLOUD Credentials
const getZegoConfig = () => ({
    appId: process.env.ZEGO_APP_ID ? parseInt(process.env.ZEGO_APP_ID) : 175321294,
    appSign: process.env.ZEGO_APP_SIGN || "a1fd1ccc47c5167af65311d24fc26816f8a6746bfff845dce4c0031009fe4ccc",
});

// Helper: Check if user is an Admin or any Lead
function isLeadOrAdminUser(user, userType) {
    if (userType !== 'volunteer' || !user) return false;
    const role = (user.role || '').trim().toLowerCase();
    return role === 'admin' || role.includes('lead') || role.startsWith('js-') || role.includes('secretary');
}

// Helper: Auto-expire scheduled conferences that are more than 1 hour past scheduled start time
const cleanExpiredScheduledConferences = async () => {
    try {
        const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
        await LiveDoubtSession.updateMany(
            {
                status: 'scheduled',
                scheduledStartTime: { $lt: oneHourAgo }
            },
            {
                $set: {
                    status: 'expired',
                    endedAt: new Date()
                }
            }
        );

        const twoHoursAgo = new Date(Date.now() - 2 * 60 * 60 * 1000);
        await LiveDoubtSession.updateMany(
            {
                status: 'ongoing',
                startedAt: { $lt: twoHoursAgo }
            },
            {
                $set: {
                    status: 'completed',
                    endedAt: new Date()
                }
            }
        );
    } catch (e) {
        console.error('Clean Expired Conferences Error:', e);
    }
};

// 1. Student requests a live video doubt session (Anytime 24/7)
const requestLiveCall = async (req, res) => {
    try {
        await cleanExpiredScheduledConferences();
        if (req.userType !== 'student') {
            return res.status(403).json({ error: "Only students can request live doubt calls." });
        }

        // Check if student already has a pending, scheduled, or ongoing call
        const existingSession = await LiveDoubtSession.findOne({
            studentId: req.user._id,
            status: { $in: ['waiting', 'scheduled', 'ongoing'] }
        });

        if (existingSession) {
            return res.status(400).json({
                error: "You already have an active or scheduled doubt session in progress.",
                session: existingSession
            });
        }

        const { subject, topic } = req.body;
        if (!subject || !subject.trim() || !topic || topic.trim().length < 3) {
            return res.status(400).json({ error: "Subject and a valid topic description (at least 3 characters) are required." });
        }

        const channelName = `doubt_room_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
        const newSession = new LiveDoubtSession({
            studentId: req.user._id,
            studentName: req.user.name || "Student",
            studentClass: req.user.studentClass || "N/A",
            subject: subject.trim(),
            topic: topic.trim(),
            channelName,
            status: 'waiting'
        });

        await newSession.save();

        res.status(201).json({
            success: true,
            message: "Doubt request submitted successfully. A Lead Mentor will schedule your video conference soon.",
            session: newSession
        });
    } catch (err) {
        console.error("Live Call Request Error:", err);
        res.status(500).json({ error: "Server error creating live doubt request." });
    }
};

// 2. Leads get the live queue (Leads & Admin only)
const getLiveQueue = async (req, res) => {
    try {
        await cleanExpiredScheduledConferences();
        if (!isLeadOrAdminUser(req.user, req.userType)) {
            return res.status(403).json({
                success: false,
                error: "Access denied. Only Leads and Admins can view and manage doubt conference schedules."
            });
        }

        const waitingSessions = await LiveDoubtSession.find({ status: 'waiting' }).sort({ requestedAt: 1 });
        const scheduledSessions = await LiveDoubtSession.find({ status: 'scheduled' }).sort({ scheduledStartTime: 1 });
        const ongoingSessions = await LiveDoubtSession.find({ status: 'ongoing' }).sort({ startedAt: -1 });

        res.status(200).json({
            success: true,
            waiting: waitingSessions,
            scheduled: scheduledSessions,
            ongoing: ongoingSessions
        });
    } catch (err) {
        console.error("Get Live Queue Error:", err);
        res.status(500).json({ error: "Failed to fetch live queue." });
    }
};

// 3. Lead sets a scheduled time for a student doubt session (Leads & Admin only)
const scheduleLiveCall = async (req, res) => {
    try {
        if (!isLeadOrAdminUser(req.user, req.userType)) {
            return res.status(403).json({
                success: false,
                error: "Access denied. Only Leads and Admins can schedule doubt conferences."
            });
        }

        const sessionId = req.params.id;
        const { scheduledStartTime, scheduledEndTime, durationMinutes = 30 } = req.body;

        if (!scheduledStartTime) {
            return res.status(400).json({ error: "Scheduled start time is required." });
        }

        if (typeof scheduledStartTime !== 'string' || !/(?:[zZ]|[+-]\d{2}:\d{2})$/.test(scheduledStartTime)) {
            return res.status(400).json({
                error: "Scheduled start time must include a timezone offset."
            });
        }

        const start = new Date(scheduledStartTime);
        const end = scheduledEndTime ? new Date(scheduledEndTime) : new Date(start.getTime() + durationMinutes * 60000);

        if (isNaN(start.getTime())) {
            return res.status(400).json({ error: "Invalid scheduled start time format." });
        }

        // Atomically schedule if still waiting
        const session = await LiveDoubtSession.findOneAndUpdate(
            { _id: sessionId, status: 'waiting' },
            {
                status: 'scheduled',
                scheduledStartTime: start,
                scheduledEndTime: end,
                scheduledBy: req.user._id,
                scheduledByName: req.user.name || req.user.role || "Lead Mentor",
                scheduledByRole: req.user.role || "Lead"
            },
            { new: true }
        );

        if (!session) {
            const existing = await LiveDoubtSession.findById(sessionId);
            if (existing && existing.status === 'scheduled') {
                return res.status(409).json({
                    error: `This doubt has already been scheduled by ${existing.scheduledByName || 'another lead'} (${existing.scheduledByRole || 'Lead'}).`
                });
            }
            return res.status(404).json({ error: "Doubt request not found or already processed." });
        }

        res.status(200).json({
            success: true,
            message: "Conference scheduled successfully.",
            session
        });
    } catch (err) {
        console.error("Schedule Live Call Error:", err);
        res.status(500).json({ error: "Failed to schedule live call." });
    }
};

// 4. Start / Join a scheduled call (Leads & Student, within appointed time window)
const startLiveCall = async (req, res) => {
    try {
        await cleanExpiredScheduledConferences();
        const sessionId = req.params.id;
        const session = await LiveDoubtSession.findById(sessionId);

        if (!session) {
            return res.status(404).json({ error: "Session not found." });
        }

        if (session.status !== 'scheduled' && session.status !== 'ongoing') {
            return res.status(400).json({ error: `Cannot start call in '${session.status}' status.` });
        }

        // Time window check: Room opens 5 mins before scheduled time until 15 mins after end
        if (session.scheduledStartTime) {
            const now = Date.now();
            const startWindow = session.scheduledStartTime.getTime() - (5 * 60 * 1000); // 5 mins early allowed
            const endWindow = session.scheduledEndTime 
                ? session.scheduledEndTime.getTime() + (15 * 60 * 1000) 
                : session.scheduledStartTime.getTime() + (45 * 60 * 1000);

            if (now < startWindow) {
                const formattedTime = session.scheduledStartTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                return res.status(400).json({ 
                    error: `Conference is scheduled for ${formattedTime}. The room opens 5 minutes before the scheduled time.` 
                });
            }

            if (now > endWindow) {
                return res.status(400).json({ 
                    error: "The scheduled conference time window has expired." 
                });
            }
        }

        // Transition from scheduled to ongoing
        if (session.status === 'scheduled') {
            session.status = 'ongoing';
            session.startedAt = new Date();
            if (req.userType === 'volunteer') {
                session.acceptedBy = req.user._id;
                session.acceptedByName = req.user.name || req.user.role || "Lead Mentor";
            }
            await session.save();
        }

        const zego = getZegoConfig();
        const isLead = req.userType === 'volunteer';

        res.status(200).json({
            success: true,
            message: "Joining conference room.",
            session,
            appId: zego.appId,
            appSign: zego.appSign,
            channelName: session.channelName,
            userId: req.user._id.toString(),
            userName: req.user.name || (isLead ? "Lead Mentor" : "Student"),
            isLead
        });
    } catch (err) {
        console.error("Start Live Call Error:", err);
        res.status(500).json({ error: "Failed to start live call." });
    }
};

// 5. Student checks current live status & receives appointment/connection info
const checkMyStatus = async (req, res) => {
    try {
        await cleanExpiredScheduledConferences();
        const session = await LiveDoubtSession.findOne({
            studentId: req.user._id,
            status: { $in: ['waiting', 'scheduled', 'ongoing'] }
        });

        if (!session) {
            return res.status(200).json({
                active: false
            });
        }

        let connectionData = null;
        let canJoin = false;

        if (session.status === 'ongoing') {
            canJoin = true;
            const zego = getZegoConfig();
            connectionData = {
                appId: zego.appId,
                appSign: zego.appSign,
                channelName: session.channelName,
                userId: req.user._id.toString(),
                userName: req.user.name || "Student"
            };
        } else if (session.status === 'scheduled' && session.scheduledStartTime) {
            const now = Date.now();
            const startWindow = session.scheduledStartTime.getTime() - (5 * 60 * 1000);
            const endWindow = session.scheduledEndTime 
                ? session.scheduledEndTime.getTime() + (15 * 60 * 1000) 
                : session.scheduledStartTime.getTime() + (45 * 60 * 1000);

            canJoin = now >= startWindow && now <= endWindow;
            if (canJoin) {
                const zego = getZegoConfig();
                connectionData = {
                    appId: zego.appId,
                    appSign: zego.appSign,
                    channelName: session.channelName,
                    userId: req.user._id.toString(),
                    userName: req.user.name || "Student"
                };
            }
        }

        res.status(200).json({
            active: true,
            status: session.status,
            canJoin,
            session,
            connection: connectionData
        });
    } catch (err) {
        console.error("Check My Status Error:", err);
        res.status(500).json({ error: "Failed to check session status." });
    }
};

// 6. Cancel request (Student side before call completes)
const cancelLiveRequest = async (req, res) => {
    try {
        const session = await LiveDoubtSession.findOneAndUpdate(
            { studentId: req.user._id, status: { $in: ['waiting', 'scheduled'] } },
            { status: 'cancelled' },
            { new: true }
        );

        res.status(200).json({
            success: true,
            message: session ? "Doubt session cancelled." : "No pending doubt session found."
        });
    } catch (err) {
        console.error("Cancel Live Request Error:", err);
        res.status(500).json({ error: "Failed to cancel request." });
    }
};

// 7. End ongoing call
const endLiveCall = async (req, res) => {
    try {
        const sessionId = req.params.id;
        const session = await LiveDoubtSession.findById(sessionId);

        if (session && session.status === 'ongoing') {
            session.status = 'completed';
            session.endedAt = new Date();
            if (session.startedAt) {
                session.durationSeconds = Math.round(
                    (session.endedAt.getTime() - session.startedAt.getTime()) / 1000
                );
            }
            await session.save();
        }

        res.status(200).json({
            success: true,
            message: "Call ended successfully."
        });
    } catch (err) {
        console.error("End Live Call Error:", err);
        res.status(500).json({ error: "Failed to end call." });
    }
};

module.exports = {
    requestLiveCall,
    getLiveQueue,
    scheduleLiveCall,
    startLiveCall,
    checkMyStatus,
    cancelLiveRequest,
    endLiveCall
};
