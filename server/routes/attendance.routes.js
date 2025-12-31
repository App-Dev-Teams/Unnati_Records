const express=require('express');
const { markAttendance, getAttendanceByDate, getUserAttendance } = require('../controllers/attendance.controller.js');
const attendanceRouter=express.Router();

attendanceRouter.patch('/mark',markAttendance);
attendanceRouter.get('/date',getAttendanceByDate);
attendanceRouter.get('/user/:id',getUserAttendance);

module.exports=attendanceRouter;