const OTP = require("../models/otp.model");
const { generateOtp, sendOtpMail } = require("../utils/sendEmail");

// SEND OTP
exports.sendOtp = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ error: "Email required" });
    }

    await OTP.deleteMany({ email });

    const otp = generateOtp();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    await OTP.create({ email, otp, expiresAt });

    await sendOtpMail(email, otp);

    res.json({ message: "OTP sent successfully" });

  } catch (err) {
    console.error(err.response?.data || err.message);
    res.status(500).json({ error: "Failed to send OTP" });
  }
};

// VERIFY OTP
exports.verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) {
      return res.status(400).json({ error: "Email & OTP required" });
    }

    const record = await OTP.findOne({ email, otp });

    if (!record) {
      return res.status(400).json({ error: "Invalid OTP" });
    }

    if (record.expiresAt < new Date()) {
      await OTP.deleteOne({ _id: record._id });
      return res.status(400).json({ error: "OTP expired" });
    }

    await OTP.deleteOne({ _id: record._id });

    res.json({ message: "OTP verified successfully" });

  } catch (err) {
    res.status(500).json({ error: "OTP verification failed" });
  }
};
