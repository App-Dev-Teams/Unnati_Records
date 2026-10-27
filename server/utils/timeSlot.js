/**
 * Time Slot Validator for Live Video Doubt Solving
 * Allowed window: 5:00 PM to 12:00 AM (17:00 to 23:59 IST)
 * Can be bypassed in development with BYPASS_TIME_RESTRICTION=true
 */
const isLiveDoubtWindowOpen = () => {
    if (process.env.BYPASS_TIME_RESTRICTION === 'true') {
        return true;
    }

    // Convert current time to Indian Standard Time (IST: UTC + 5:30)
    const now = new Date();
    const istOffsetMs = 5.5 * 60 * 60 * 1000;
    const istTime = new Date(now.getTime() + istOffsetMs);

    const hours = istTime.getUTCHours(); // 0 to 23

    // Window: 17:00 (5:00 PM) to 23:59 (11:59 PM)
    return hours >= 17 && hours <= 23;
};

module.exports = { isLiveDoubtWindowOpen };
