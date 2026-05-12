const UserAttendance = require('../models/userAttendance.model.js');
const mongoose = require('mongoose');

module.exports = {

  // Sync user stats after marking AttendanceDay
  syncUserAttendance: async (attendanceDayDoc) => {
    const date = attendanceDayDoc.date;

    // Present users
    for (const userId of attendanceDayDoc.presentUserId) {
      await UserAttendance.findOneAndUpdate(
        { userId },
        { $addToSet: { present: date } },  //array mein date add only when it's not present in it
        { upsert: true }
      );
    }

    // Absent users
    for (const userId of attendanceDayDoc.absentUserId) {
      await UserAttendance.findOneAndUpdate(
        { userId },
        { $addToSet: { absent: date } },
        { upsert: true }
      );
    }

    // Cancelled users
    for (const userId of attendanceDayDoc.cancelledUserId) {
      await UserAttendance.findOneAndUpdate(
        { userId },
        { $addToSet: { cancelled: date } },
        { upsert: true }
      );
    }
  },


  
  // Get user monthly + yearly stats
  getUserMonthlyStats: async (userId, month, year) => {
    const userAttendance = await UserAttendance.findOne({userId:userId}).lean();
    console.log(userAttendance);

    if (!userAttendance) {
      console.log("No UserAttendance doc found");
      return {
        totalClasses: 0,
        presentCount: 0,
        absentCount: 0,
        cancelledCount: 0
      };
    }
    
    //show total attendance stats
    if(!month || !year){
    const presentCount = userAttendance.present.length;
    const absentCount = userAttendance.absent.length;
    const cancelledCount = userAttendance.cancelled.length;

    return {
      presentCount,
      absentCount,
      cancelledCount,
      totalClasses: presentCount + absentCount
    };
  }

    const filterByMonthYear = (dates) => {
    return (dates || []).filter(d => {
      const dt = new Date(d);
      return (
        dt.getUTCFullYear() === parseInt(year) &&
        (dt.getUTCMonth() + 1) === parseInt(month)
      );
    });
  };

    const presentCount = filterByMonthYear(userAttendance.present).length;
    const absentCount = filterByMonthYear(userAttendance.absent).length;
    const cancelledCount = filterByMonthYear(userAttendance.cancelled).length;
    const totalClasses = presentCount + absentCount; // cancel not counted

    return { totalClasses, presentCount, absentCount, cancelledCount };
  }

};
