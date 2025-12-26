const USER = require("../models/user.model.js");
const bcrypt = require("bcrypt");
const { validationResult } = require("express-validator");
const jwt= require("jsonwebtoken")
const STUDENT = require("../models/student.model.js");

//=================USER SIGNUP=======================
const signup = async (req, res) => {
  const errors = validationResult(req);  // if validation conditions are not follwed then store errors here
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { name, email, password, batch, rollNo} = req.body;

    const existingUser = await USER.findOne({ email });
    if (existingUser) {
      return res.status(422).json({ error: "User already exists with this email" });
    }
    
    //hashing the password
    const hashedPassword = await bcrypt.hash(password, 12);

    const newUser = new USER({
      name,
      email,
      role:'volunteer',
      password: hashedPassword,
      batch, 
      rollNo
    });

    await newUser.save();
    
    //token generation
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
        rollNo:newUser.rollNo,
        batch:newUser.batch
      },
    });

  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal server error" });
  }
};

//===================USER LOGIN======================
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const saveduser = await USER.findOne({ email });

    if (!saveduser) {
      return res.status(401).json({
        success: false,
        message: "User does not exist",
      });
    }
    
    //comparison of the given password and saved password using bcrypt
    const isMatch = await bcrypt.compare(password, saveduser.password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }
    
    //fresh token generation
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
        email: saveduser.email,
        role: saveduser.role,
        rollNo:saveduser.rollNo,
        batch:saveduser.batch
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

//==================STUDENT SIGNUP======================
const studentSignup = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      errors: errors.array()
    });
  }

  try {
    const { name, email, password, phoneNo, studentClass, school } = req.body;

    // check if email OR phone already exists
    const existingStudent = await STUDENT.findOne({
      email
    });

    if (existingStudent) {
      return res.status(409).json({
        success: false,
        message: "Email already registered"
      });
    }

    // hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    const newStudent = new STUDENT({
      name,
      email,
      password: hashedPassword,
      phoneNo,
      studentClass,
      school
    });

    await newStudent.save();

    // generate token
    const token = jwt.sign(
      { id: newStudent._id },
      process.env.JWT_SECRET,
      { expiresIn: "14d" }
    );

    return res.status(201).json({
      success: true,
      message: "Signup successful",
      token,
      data: {
        id: newStudent._id,
        name: newStudent.name,
        email: newStudent.email,
        phoneNo: newStudent.phoneNo,
        studentClass: newStudent.studentClass,
        school: newStudent.school
      }
    });

  } catch (error) {
    console.error("SIGNUP ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};


//================== STUDENT LOGIN======================
const studentLogin = async (req, res) => {
  try {
    const { email, password } = req.body;

    const student = await STUDENT
      .findOne({ email })
      .select("+password");

      console.log(student);

    if (!student) {
      return res.status(401).json({
        success: false,
        message: "User does not exist"
      });
    }

    const isMatch = await bcrypt.compare(password, student.password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: "Invalid password"
      });
    }

    const token = jwt.sign(
      { id: student._id },
      process.env.JWT_SECRET,
      { expiresIn: "14d" }
    );

    return res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      data: {
        id: student._id,
        name: student.name,
        email: student.email,
        phoneNo: student.phoneNo,
        studentClass: student.studentClass,
        school: student.school
      }
    });

  } catch (error) {
    console.error("LOGIN ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};

//================== Volunteer UPDATE PASSWORD ======================

const updatePassword = async (req, res) => {
  try {
    const { email, newPassword } = req.body;

    if (!email || !newPassword) {
      return res.status(400).json({
        error: "Email and new password are required"
      });
    }

    // hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 12);

    // update password in DB
    const user = await USER.findOneAndUpdate(
      { email },
      { password: hashedPassword },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({
        error: "User not found"
      });
    }

    return res.json({
      message: "Password updated successfully"
    });

  } catch (err) {
    console.error(err);
    return res.status(500).json({
      error: "Failed to update password"
    });
  }
};


module.exports = { studentSignup, studentLogin,signup,login , updatePassword};


