const express=require('express');
const { getAllFolders, createFolder, updateFolder, deleteFolder } = require('../controllers/folder.controller');
const requireLogin = require('../middlewares/requireLogin');
const authorize = require('../middlewares/authorize');
const folderRouter=express.Router();

folderRouter.get('/folders', requireLogin,getAllFolders);          
folderRouter.post('/folders',requireLogin,authorize("UPLOAD_RESOURCE") ,createFolder);        
folderRouter.patch('/folders/:id',requireLogin,authorize("UPLOAD_RESOURCE") , updateFolder);     // partial update so patch
folderRouter.delete('/folders/:id',requireLogin,authorize("UPLOAD_RESOURCE") , deleteFolder);    

module.exports=folderRouter;