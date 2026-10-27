const express=require('express');
const { updateProfilePic, getProfileImageKitAuth } = require('../controllers/profile_controller');
const requireLogin = require('../middlewares/requireLogin');
const profileRouter = express.Router();
profileRouter.get("/imagekit/profile-auth",requireLogin,getProfileImageKitAuth);
profileRouter.put("/profile-picture",requireLogin,updateProfilePic);
module.exports=profileRouter;