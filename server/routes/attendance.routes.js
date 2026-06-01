const express=require('express');
const { markAttendance, getAttendanceByDate, getUserAttendance, getUserYearlyAttendance } = require('../controllers/attendance.controller.js');
const requireLogin = require('../middlewares/requireLogin.js');
const authorize = require('../middlewares/authorize.js');
const attendanceRouter=express.Router();

attendanceRouter.patch('/mark',requireLogin,authorize("MARK_ATTENDANCE"),markAttendance);
attendanceRouter.get('/date',requireLogin,authorize("MARK_ATTENDANCE"),getAttendanceByDate);
attendanceRouter.get('/user/:id',requireLogin,getUserAttendance);
attendanceRouter.get('/user/:id/yearly',requireLogin,getUserYearlyAttendance);

module.exports=attendanceRouter;