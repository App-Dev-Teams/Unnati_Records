const express = require("express");
const volunteerRouter = express.Router();

const { getAllUsers, getUsersByProgram } = require("../controllers/volunteer.controller.js");

// for now: NO admin auth
volunteerRouter.get("/get-volunteers", getAllUsers);
volunteerRouter.get("/program/get-volunteers", getUsersByProgram);


module.exports = volunteerRouter;
