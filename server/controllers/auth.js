const USER = require("../models/user.js");
const bcrypt = require("bcrypt");
const { validationResult } = require("express-validator");
const jwt= require("jsonwebtoken")

const signup = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { name, email, password,role } = req.body;

    const existingUser = await USER.findOne({ email });
    if (existingUser) {
      return res.status(422).json({ error: "User already exists with this email" });
    }

    const hashedPassword = await bcrypt.hash(password, 12);

    const newUser = new USER({
      name,
      email,
      role,
      password: hashedPassword
    });

    await newUser.save();

    const token = jwt.sign(
      { _id: newUser._id },
      process.env.JWT_SECRET,
      { expiresIn: "14d" }
    );

    return res.status(200).json({
      token,
      success: true,
      message: "User registered successfully",
      data: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        role: newUser.role,
      },
    });

  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal server error" });
  }
};


const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const saveduser = await USER.findOne({ email });

    if (!saveduser) {
      return res.status(400).json({
        success: false,
        message: "User does not exist",
      });
    }

    const isMatch = await bcrypt.compare(password, saveduser.password);

    if (!isMatch) {
      return res.status(422).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    const token = jwt.sign(
      { _id: saveduser._id },
      process.env.JWT_SECRET,
      { expiresIn: "14d" }
    );

    return res.status(200).json({
      success: true,
      message: "User logged in successfully",
      token,
      data: {
        id:saveduser._id,
        name: saveduser.name,
        email: saveduser.email
      },
    });

  } catch (error) {
    console.log("LOGIN ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
};

module.exports = { signup ,login };
