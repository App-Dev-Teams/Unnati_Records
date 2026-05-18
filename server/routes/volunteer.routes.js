const express = require("express");
const volunteerRouter = express.Router();

const { getAllUsers, getUsersByProgram, assignRole } = require("../controllers/volunteer.controller.js");

// for now: NO admin auth
volunteerRouter.get("/get-volunteers", getAllUsers);
volunteerRouter.get("/program/get-volunteers", getUsersByProgram);
volunteerRouter.put("/assign-role", assignRole);

module.exports = volunteerRouter;
