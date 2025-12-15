
const jwt = require('jsonwebtoken')
const mongoose = require('mongoose');
const User = require('../models/user');

module.exports = (req,res,next)=>{
    const {authorization} = req.headers;
    if(!authorization){
        res.status(401).json({error:"You must be logged in"})
    }
    const token = authorization.replace("Bearer ","")
    jwt.verify(token,process.env.JWT_SECRET,(err,payload)=>{
        if(err){
            res.status(401).json({error:"you must be logged in"});
        }
        const {_id} = payload  //stored in jwt
        User.findById(_id).then(userdata=>{
            req.user = userdata
             next();
        })
       
    })
}