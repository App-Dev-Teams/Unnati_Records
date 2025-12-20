const express = require("express");
const router = express.Router();

const { getAllUsers } = require("../controllers/volunteerController");

// for now: NO admin auth
router.get("/get-volunteers", getAllUsers);

module.exports = router;
