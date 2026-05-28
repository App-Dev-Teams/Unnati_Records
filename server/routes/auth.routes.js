const express = require('express');
const bcrypt = require('bcrypt');
const { body, validationResult } = require('express-validator');
const requireLogin = require('../middlewares/requireLogin');
const { login, signup, studentSignup, studentLogin, updatePassword, updateProfile } = require('../controllers/auth.controller');

const router = express.Router();

//Unanti member signup validation
const signupValidation = [
  body('name')
    .notEmpty().withMessage('Name is required')
    .isLength({ min: 3 }).withMessage('Name must be at least 3 characters'),

  body('email')
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Invalid email'),

  body('password')
    .notEmpty().withMessage('Password is required')
    .isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),


];


// Student Signup Validation
const studentSignupValidation = [
  body("name")
    .notEmpty().withMessage("Name is required")
    .trim(),

  body("email")
    .notEmpty().withMessage("Email is required")
    .isEmail().withMessage("Invalid email format")
    .trim(),

  body("password")
    .notEmpty().withMessage("Password is required")
    .isLength({ min: 6 }).withMessage("Password must be at least 6 characters"),

  body("phoneNo")
    .notEmpty().withMessage("Phone number is required")
    .matches(/^[0-9]{10}$/).withMessage("Phone number must be 10 digits"),

  body("school")
    .notEmpty().withMessage("School is required")
    .trim(),

  body("studentClass")
    .notEmpty().withMessage("Class is required")
    .trim(),
];


//Common login validation
const loginValidation = [
  body("email")
    .notEmpty().withMessage("Email is required")
    .isEmail().withMessage("Invalid email")
    .normalizeEmail(),

  body("password")
    .notEmpty().withMessage("Password is required"),
];

const updateProfileValidation = [
  body("name")
    .optional({ nullable: true })
    .trim()
    .isLength({ min: 3 }).withMessage("Name must be at least 3 characters"),

  body("phoneNo")
    .optional({ nullable: true })
    .trim()
    .matches(/^[0-9]{10}$/).withMessage("Phone number must be 10 digits"),

  body("program")
    .optional({ nullable: true })
    .trim()
    .isLength({ min: 1 }).withMessage("Program is required"),

  body("batchYear")
    .optional({ nullable: true })
    .isInt({ min: 1900, max: 9999 }).withMessage("Invalid batch year")
    .toInt(),

  body("studentClass")
    .optional({ nullable: true })
    .trim()
    .isLength({ min: 1 }).withMessage("Class is required"),

  body("school")
    .optional({ nullable: true })
    .trim()
    .isLength({ min: 1 }).withMessage("School is required"),

  (req, res, next) => {
    const hasAnyUpdateField = [
      "name",
      "phoneNo",
      "program",
      "batchYear",
      "studentClass",
      "school",
    ].some((field) => {
      const value = req.body[field];
      return value !== undefined && value !== null && value !== "";
    });

    if (!hasAnyUpdateField) {
      return res.status(400).json({
        success: false,
        error: "At least one field is required to update profile",
      });
    }

    next();
  },

  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: "Validation failed",
        errors: errors.array(),
      });
    }

    next();
  },
];


//GET: protected route- only for logged in users
router.get('/protected', requireLogin, (req, res) => {
  res.send("only for logged in users")
})

//POST: Unnati members signup route  
router.post('/signup', signupValidation, signup)

//POST: Unnati members login route
router.post('/login', loginValidation, login)


// POST: Student Signup route
router.post("/studentSignup", studentSignupValidation, studentSignup);

// POST: Student Login route
router.post("/studentLogin", loginValidation, studentLogin);

// POST: Volunteer UPDATE PASSWORD route
router.post("/update-password", updatePassword);

router.put("/update-profile", requireLogin, updateProfileValidation, updateProfile);

module.exports = router;