const express=require('express');
const { getFilesByFolder, createFile, updateFile, deleteFile, getImageKitAuth, getAllFiles } = require('../controllers/file');
const fileRouter=express.Router();

fileRouter.get('/imagekit/auth', getImageKitAuth);
fileRouter.post('/files', createFile);                       // create file metadata
fileRouter.get('/files/folder/:folderId', getFilesByFolder); // folder-wise file fetch
fileRouter.get('/files', getAllFiles);                       // get All files
fileRouter.patch('/files/:id', updateFile);                  // rename file
fileRouter.delete('/files/:id', deleteFile);

module.exports=fileRouter;