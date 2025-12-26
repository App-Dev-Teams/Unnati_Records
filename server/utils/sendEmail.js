const axios = require("axios");

const BREVO_URL = "https://api.brevo.com/v3/smtp/email";

const generateOtp = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const sendOtpMail = async (email, otp) => {
  if (!process.env.BREVO_API_KEY) {
    throw new Error("BREVO_API_KEY missing");
  }

  const payload = {
    sender: {
      email: process.env.EMAIL_FROM,
      name: "Test Unnati"
    },
    to: [
      {
        email: email
      }
    ],
    subject: "OTP Verification - Unnati",
    htmlContent: `
      <h2>This is a test of Email Verification backend , please ignore (lol) </h2>
      <p>Your OTP is:</p>
      <h1>${otp}</h1>
      <p>Valid for 5 minutes.</p>
    `
  };

  await axios.post(BREVO_URL, payload, {
    headers: {
      "api-key": process.env.BREVO_API_KEY,
      "Content-Type": "application/json"
    }
  });
};

module.exports = { generateOtp, sendOtpMail };
