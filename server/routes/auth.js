const express=require('express');
const bcrypt=require('bcrypt');
const { body, validationResult } = require('express-validator');
const requireLogin = require('../middlewares/requireLogin');
const { login, signup, studentSignup, studentLogin } = require('../controllers/auth');

const router=express.Router();

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

  body('batch')
    .notEmpty().withMessage('Batch is required')
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


//GET: protected route- only for logged in users
router.get('/protected',requireLogin,(req,res)=>{
    res.send("only for logged in users")
})

//POST: Unnati members signup route  
router.post('/signup',signupValidation,signup)

//POST: Unnati members login route
router.post('/login',loginValidation,login)


// POST: Student Signup route
router.post("/studentSignup", studentSignupValidation,studentSignup);

// POST: Student Login route
router.post("/studentLogin", loginValidation,studentLogin);

module.exports=router;