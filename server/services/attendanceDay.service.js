const AttendanceDay = require('../models/attendanceDay.model.js');
const mongoose = require('mongoose');

module.exports = {

  //  Mark or Update attendance for a date
  markAttendanceForDate: async (date, presentIds = [], absentIds = [], cancelledIds = []) => {

    // Find 
    let attendance = await AttendanceDay.findOne({ date });
    
    //create 
    if (!attendance) {
      attendance = new AttendanceDay({
        date,
        presentUserId: [],
        absentuserId: [],
        cancelledUserId: []
      });
    }

    // Remove users from all arrays first for avoiding duplicacy
    const allIds = [...presentIds, ...absentIds, ...cancelledIds].map(id => id.toString());
    attendance.presentUserId = attendance.presentUserId.filter(id => !allIds.includes(id.toString()));
    attendance.absentUserId = attendance.absentUserId.filter(id => !allIds.includes(id.toString()));
    attendance.cancelledUserId = attendance.cancelledUserId.filter(id => !allIds.includes(id.toString()));

    // Pushing into correct arrays
    attendance.presentUserId.push(...presentIds);
    attendance.absentUserId.push(...absentIds);
    attendance.cancelledUserId.push(...cancelledIds);

    await attendance.save();
    return attendance;
  },


  
  
  // Get attendance by date with optional filters
  getAttendanceByDate: async (date, filters = {}) => {
    const { status, program, batch } = filters;

    const attendance = await AttendanceDay.findOne({ date })
    .populate("presentUserId", "name email")
    .populate("absentUserId", "name email")
    .populate("cancelledUserId", "name email")
    .lean();
    if (!attendance) return { present: [], absent: [], cancelled: [] };

    let result = {
      present: attendance.presentUserId,
      absent: attendance.absentUserId,
      cancelled: attendance.cancelledUserId
    };

    if (status) {
      result = { [status]: result[status] || [] };
    }

    return result;
  }
};
