const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER, // your gmail
    pass: process.env.EMAIL_PASS  // app password
  }
});

const generateOtp = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const sendOtpMail = async (email, otp) => {
  await transporter.sendMail({
    from: `"Unnati" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: "Your OTP for Verification",
    html: `
      <h2>Email Verification</h2>
      <p>Your OTP is:</p>
      <h1>${otp}</h1>
      <p>This OTP is valid for 5 minutes.</p>
    `
  });
};

module.exports = { generateOtp, sendOtpMail };
