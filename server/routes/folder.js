const express=require('express');
const { getAllFolders, createFolder, updateFolder, deleteFolder } = require('../controllers/folder');
const folderRouter=express.Router();

folderRouter.get('/folders', getAllFolders);          
folderRouter.post('/folders', createFolder);        
folderRouter.patch('/folders/:id', updateFolder);     // partial update so patch
folderRouter.delete('/folders/:id', deleteFolder);    

module.exports=folderRouter;