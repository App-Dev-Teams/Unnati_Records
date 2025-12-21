const express = require("express");
const router = express.Router();

const { getAllUsers } = require("../controllers/volunteer.controller.js");

// for now: NO admin auth
router.get("/get-volunteers", getAllUsers);

module.exports = router;
