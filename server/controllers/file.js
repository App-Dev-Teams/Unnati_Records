const FILES = require("../models/file");
const ImageKit = require('imagekit');
const dotenv= require('dotenv');
dotenv.config();

//backend gives token to frontend then frontend sends it to imagekit and then frontend receives the url 
// which is sent in the post request to backend which further gets saved in mongodb
//private key will never go in frontend

//IMAGEKIT OBJECT CREATION: it helps you in using imagekit's methods
const imagekit = new ImageKit({
  publicKey: process.env.IMAGEKIT_PUBLIC_KEY,
  privateKey: process.env.IMAGEKIT_PRIVATE_KEY,
  urlEndpoint: process.env.IMAGEKIT_URL_ENDPOINT,
}); 


//IMAGEKIT TOKEN:imagekitauth token generation
const getImageKitAuth = (req, res) => {
  try {
    const authParams = imagekit.getAuthenticationParameters();

    res.status(200).json(authParams);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to generate ImageKit auth'
    });
  }
};


//CREATE: creation of file
const createFile = async (req, res) => {
  try {
    const { originalName, displayName, link, folder,type ,imagekitFileId} = req.body;

    if (!link) {
      return res.status(400).json({ message: 'File link is required' });
    }

    if (!displayName) {
      return res.status(400).json({ message: 'File name is required' });
    }

    if (!imagekitFileId) {
      console.warn("ImageKit fileId missing for file:", _id);
    }

    const file = await FILES.create({
      imagekitFileId,
      displayName,
      originalName,
      link,
      folder,
      type,
    });

    res.status(201).json(file);
  } catch (error) {
    res.status(500).json({ message: 'Failed to save file' });
  }
};


// GET: all files
const getAllFiles = async (req, res) => {
  try {
    const files = await FILES.find()
      .sort({ createdAt: -1 })
      .populate('folder', 'name className'); 

    res.status(200).json(files);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Failed to fetch files"
    });
  }
};


//GET:Folder-wise file fetch
const getFilesByFolder = async (req, res) => {
  try {
    const { folderId } = req.params;

    if (!folderId) {
      return res.status(400).json({ message: "Folder ID is required" });
    }

    // find files with given folderId
    const files = await FILES.find({ folder: folderId }).sort({ createdAt: -1 });

    res.status(200).json(files);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to fetch files" });
  }
};


//UPDATE: displayname can be edited.
const updateFile = async (req, res) => {
  try {
    const { id } = req.params;
    const { displayName } = req.body;

    // displayName field must be present
    if (displayName === undefined) {
      return res.status(400).json({
        message: "displayName is required"
      });
    }

    // empty string not allowed
    if (displayName.trim() === "") {
      return res.status(400).json({
        message: "displayName cannot be empty"
      });
    }

    const file = await FILES.findByIdAndUpdate(
      id,
      { displayName },
      { new: true, runValidators: true }
    );

    if (!file) {
      return res.status(404).json({
        message: "File not found"
      });
    }

    res.status(200).json(file);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Failed to update file name"
    });
  }
};


//DELETE: delete file from both imagekit and mongodb
const deleteFile = async (req, res) => {
  try {
    const { id } = req.params; // MongoDB file id

    //  Fetch file record from DB
    const file = await FILES.findById(id);
    if (!file) {
      return res.status(404).json({ message: "File not found" });
    }

    //async has been used with promise just to make sure first file gets deleted from imagekit and then from mongodb
    //promise will give the result(pass/fail) of a work being executed in future
    // 1. Delete file from ImageKit
    const fileId = file.imagekitFileId; 
    if (fileId) {
      await new Promise((resolve, reject) => {
        imagekit.deleteFile(fileId, function (error, result) {
          if (error) reject(error);
          else resolve(result);
        });
      });
    }

    // 2. Delete file from MongoDB
    await FILES.findByIdAndDelete(id);

    res.status(200).json({ message: "File deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to delete file" });
  }
};


module.exports={createFile,getFilesByFolder,getImageKitAuth,deleteFile,updateFile,getAllFiles};