const express = require("express");
const router = express.Router();

const {
  sendOtp,
  verifyOtp
} = require("../controllers/otpController");

router.post("/send-otp", sendOtp);
router.post("/verify-otp", verifyOtp);

module.exports = router;