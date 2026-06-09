const express = require("express");
const volunteerRouter = express.Router();

const { getAllUsers, getUsersByProgram,  updateRole } = require("../controllers/volunteer.controller.js");

// for now: NO admin auth
volunteerRouter.get("/get-volunteers", getAllUsers);
volunteerRouter.get("/program/get-volunteers", getUsersByProgram);
volunteerRouter.put("/update-role", updateRole);

module.exports = volunteerRouter;
