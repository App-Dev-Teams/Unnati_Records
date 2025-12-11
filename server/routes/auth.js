const express=require('express');
const bcrypt=require('bcrypt');
const { body, validationResult } = require('express-validator');
const USER = require('../models/user');
const requireLogin = require('../middlewares/requireLogin');
const { login, signup } = require('../controllers/auth');

const router=express.Router();

router.get('/protected',requireLogin,(req,res)=>{
    res.send("only for logged in users")
})

router.post('/signup',[
    body('name').isLength({min:3}).withMessage('Name >=2 chars'),
    body('email').isEmail().withMessage('Invalid email'),
    body('password').isLength({min:6}).withMessage('password >=6 chars')
],signup)

router.post('/login',login)

module.exports=router;