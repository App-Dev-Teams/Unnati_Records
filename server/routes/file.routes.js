const express=require('express');
const { getFilesByFolder, createFile, updateFile, deleteFile, getImageKitAuth, getAllFiles } = require('../controllers/file.controller');
const requireLogin = require('../middlewares/requireLogin');
const authorize = require('../middlewares/authorize');
const fileRouter=express.Router();

fileRouter.get('/imagekit/auth',requireLogin,authorize("UPLOAD_RESOURCE"), getImageKitAuth);
fileRouter.post('/files',requireLogin,authorize("UPLOAD_RESOURCE") , createFile);                       // create file metadata
fileRouter.get('/files/folder/:folderId',requireLogin, getFilesByFolder); // folder-wise file fetch
fileRouter.get('/files',requireLogin, getAllFiles);                       // get All files
fileRouter.patch('/files/:id',requireLogin,authorize("UPLOAD_RESOURCE") , updateFile);                  // rename file
fileRouter.delete('/files/:id',requireLogin,authorize("UPLOAD_RESOURCE") , deleteFile);

module.exports=fileRouter;