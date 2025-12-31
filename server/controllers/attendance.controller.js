const { normalizeDate } = require('../utils/date.util.js');
const attendanceDayService = require('../services/attendanceDay.service.js');
const userAttendanceService = require('../services/userAttendance.service.js');

module.exports = {
  // Mark or Update Attendance
  markAttendance: async (req, res) => {
    try {
      const {
        date,
        presentUserId = [],
        absentUserId = [],
        cancelledUserId = []
      } = req.body;

      if (!date) {
        return res.status(400).json({ message: 'Date is required' });
      }

      // Safety check: same user in multiple arrays
      const allUsers = [...presentUserId, ...absentUserId, ...cancelledUserId];
      if (new Set(allUsers).size !== allUsers.length) {
        return res.status(400).json({
          message: 'A user cannot be in multiple states at the same time'
        });
      }

      const attendanceDate = normalizeDate(date);

      // Update AttendanceDay 
      const dayDoc = await attendanceDayService.markAttendanceForDate(
        attendanceDate,
        presentUserId,
        absentUserId,
        cancelledUserId
      );

      // Update UserAttendance
      await userAttendanceService.syncUserAttendance(dayDoc);

      return res.status(200).json({
        message: 'Attendance marked successfully',
        date: attendanceDate
      });

    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server error' });
    }
  },



  // Get attendance for a specific date
  getAttendanceByDate: async (req, res) => {
    try {
      const { date, program, batch, status } = req.query;
      if (!date) {
        return res.status(400).json({ message: 'Date is required' });
      }

      const attendanceDate = normalizeDate(date);

      const result = await attendanceDayService.getAttendanceByDate(
        attendanceDate,
        { program, batch, status }
      );

      return res.status(200).json(result);

    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server error' });
    }
  },



  //  Get user  monthly attendance
  getUserAttendance: async (req, res) => {
    try {
      const userId  = req.params.id;
      const { month, year } = req.query;
      console.log(userId);

      const stats = await userAttendanceService.getUserMonthlyStats(
        userId,
        month,
        year
      );

      return res.status(200).json(stats);

    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server error' });
    }
  }
};
