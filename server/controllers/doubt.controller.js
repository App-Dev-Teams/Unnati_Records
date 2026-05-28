const Doubt = require('../models/doubt.model');
const DoubtMessage = require('../models/doubtmessages.model');
//creating 
const createDoubt = async (req, res) => {
    try {
        const { title, description, subject } = req.body;

        if (!description || description.length < 5 || description.length > 300) {
            return res.status(400).json({ error: "Invalid doubt description" });

        }
        const newDoubt = new Doubt({
            title,
            subject,
            studentId: req.user._id,
            status: 'open',
        });
        await newDoubt.save();
        const firstMessage = new DoubtMessage({
            doubtId: newDoubt._id,
            senderId: req.user._id,
            senderRole: 'student',  // Student posting
            message: description
        });
        await firstMessage.save();

        res.status(201).json({
            success: true,
            doubt: newDoubt,
            message: firstMessage
        });

    } catch (error) {
        console.error("Error creating doubt:", error);
        return res.status(500).json({ error: "Internal server error" });
    }
};

// for student side get 

const getmyDoubts = async (req, res) => {
    try {
        const doubts = await Doubt.find({
            studentId: req.user._id
        }).sort({ createdAt: -1 });
        res.status(200).json({
            success: true,
            count: doubts.length,
            data: doubts
        });
    } catch (error) {
        console.error("Error fetching my doubts:", error);
        return res.status(500).json({ error: "Internal server error" });
    }
};

//getting doubt details 
const getDoubtDetails = async (req, res) => {
    try {
        const doubt = await Doubt.findById(req.params.id);
        if (!doubt) {
            return res.status(404).json({ error: "Doubt not found" });
        }
        res.status(200).json({
            success: true,
            data: doubt
        });
    }
    catch (error) {
        console.error("Error fetching doubt details:", error);
        return res.status(500).json({ error: "Internal server error" });
    };
};

//get msg
const getDoubtMessages = async (req, res) => {
    try {
        const doubtId = req.params.id;
        const messages = await DoubtMessage.find({ doubtId }).sort({ createdAt: 1 }).populate('senderId', 'name role');
        res.status(200).json({
            success: true,
            count: messages.length,
            data: messages
        });
    }
    catch (error) {
        console.error("Error fetching doubt messages:", error);
        return res.status(500).json({ error: "Internal server error" });
    };
};

//add msg as std
const addMessage = async (req, res) => {
    try {
        const doubtId = req.params.id;
        const { message } = req.body;
        if (!message || message.length < 5 || message.length > 300) {
            return res.status(400).json({ error: "Invalid message" });
        }
        if (req.userType !== 'student') {
            return res.status(403).json({ error: 'Only students can add messages to doubts' });
        }
        const doubt = await Doubt.findById(doubtId);

        if (!doubt) {
            return res.status(404).json({ error: "Doubt not found" });
        }
        if (doubt.status == 'closed') {
            return res.status(400).json({ error: "Cannot add message to closed doubt" });
        }
        // Ensure student owns this doubt
        if (doubt.studentId && doubt.studentId.toString() !== req.user._id.toString()) {
            return res.status(403).json({ error: 'You do not have permission to add messages to this doubt' });
        }
        const newMessage = new DoubtMessage({
            doubtId,
            senderId: req.user._id,
            senderRole: req.user.role || 'student',  // User sending message
            message: message

        });
        await newMessage.save();
        await newMessage.populate('senderId', 'name email role');
        res.status(201).json({
            success: true,
            message: newMessage
        });


    }
    catch (error) {
        console.error("Error adding message to doubt:", error);
        return res.status(500).json({ error: "Internal server error" });
    }
};
//add reply 
const addReply = async (req, res) => {
    try {
        const doubtId = req.params.id;
        const { message } = req.body;

        if (!message || message.length < 5 || message.length > 300) {
            return res.status(400).json({ error: "Invalid message" });
        }
        const doubt = await Doubt.findById(doubtId);
        if (!doubt) {
            return res.status(404).json({ error: "Doubt not found" });
        }
        if (doubt.status == 'closed') {
            return res.status(400).json({ error: "Cannot add message to closed doubt" });
        }
        if (req.userType !== 'volunteer' || !['lead', 'admin'].includes((req.user.role || '').toString())) {
            return res.status(403).json({ error: 'Only RnD lead or admin can reply to doubts' });
        }
        const newMessage = new DoubtMessage({
            doubtId,
            senderId: req.user._id,
            senderRole: req.user.role || 'lead',  // Lead or Admin
            message: message
        });
        await newMessage.save();
        await newMessage.populate('senderId', 'name email role');
        res.status(201).json({
            success: true,
            message: newMessage
        });
    }
    catch (error) {
        console.error("Error adding reply to doubt:", error);
        return res.status(500).json({ error: "Internal server error" });
    }
};

//resolve doubt button(lead side rhega ui me)
const resolveDoubt = async (req, res) => {
    try {
        const doubtId = req.params.id;
        const leadid = req.user._id;
        const doubt = await Doubt.findById(doubtId);
        if (!doubt) {
            return res.status(404).json({ error: "Doubt not found" });
        }
        if (doubt.status == 'closed') {
            return res.status(400).json({ error: "Doubt is already closed" });
        }

        if (req.userType !== 'volunteer' || !['lead', 'admin'].includes((req.user.role || '').toString())) {
            return res.status(403).json({ error: 'Only RnD lead or admin can resolve doubts' });
        }
        const userMessage = await DoubtMessage.countDocuments({
            doubtId: doubtId,
            senderId: leadid
        });
        if (userMessage == 0) {
            return res.status(400).json({ error: "Only those who have replied can resolve the doubt" });
        };
        doubt.status = 'closed';
        doubt.resolvedAt = Date.now();
        doubt.resolvedBy = leadid;
        await doubt.save();
        res.status(200).json({
            success: true,
            message: "Doubt resolved successfully",
            data: doubt
        });



    }
    catch (error) {
        console.error("Error resolving doubt:", error);
        return res.status(500).json({ error: "Internal server error" });
    }
};

//get all doubts for lead 
const getOpenDoubts = async (req, res) => {
    try {

        if (req.userType !== 'volunteer' || !['lead', 'admin'].includes((req.user.role || '').toString())) {
            return res.status(403).json({ error: 'Only RnD lead or admin can view open doubts' });
        }
        const doubts = await Doubt.find({
            status: 'open'
        })
            .populate('studentId', 'name email rollNo')
            .sort({ createdAt: -1 });

        res.status(200).json({
            success: true,
            count: doubts.length,
            data: doubts
        });

    } catch (error) {
        console.error("GET OPEN DOUBTS ERROR:", error);
        res.status(500).json({ error: error.message });
    }
};

const getClosedDoubts = async (req, res) => {
    try {
        if (req.userType !== 'volunteer' || !['lead', 'admin'].includes((req.user.role || '').toString())) {
            return res.status(403).json({ error: 'Only RnD lead or admin can view closed doubts' });
        }

        const doubts = await Doubt.find({
            status: 'closed'
        })
            .populate('studentId', 'name email rollNo')
            .populate('resolvedBy', 'name email role')
            .sort({ resolvedAt: -1 });

        res.status(200).json({
            success: true,
            count: doubts.length,
            data: doubts
        });
    } catch (error) {
        console.error('GET CLOSED DOUBTS ERROR:', error);
        res.status(500).json({ error: error.message });
    }
};

module.exports = { createDoubt, getmyDoubts, getDoubtDetails, getDoubtMessages, addMessage, addReply, resolveDoubt, getOpenDoubts, getClosedDoubts };