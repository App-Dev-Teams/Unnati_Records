const Folder = require('../models/folder.model.js');

// CREATE folder
const createFolder = async (req,res)=>{
  try {
    const { name, className } = req.body;

    if (!name) {
      return res.status(400).json({ message: 'Folder name is required' });
    }

    const folder = await Folder.create({
      name,
      className
    });

    res.status(201).json(folder);
    console.log(folder);

  } catch (error) {
    res.status(500).json({ message: 'Failed to create folder' });
  }
};


//GET all folders
const getAllFolders = async (req, res) => {
  try {
    const folders = await Folder.find().sort({ createdAt: -1 });
    res.status(200).json(folders);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch folders' });
  }
};


// UPDATE Folders
const updateFolder = async (req, res) => {
  try {
    const { name, className } = req.body;

    const updates = {};
    
    // only pass the fields which you want to update otherwise previous data will remain intact
    if (name !== undefined) {
      if (name.trim() === '') {
        return res.status(400).json({ message: 'Folder name cannot be empty' });
      }
      updates.name = name.trim();  //agar name chnage kiya to wo name otherwise previous name.
    }
    if (className !== undefined) updates.class = className;
    
    //agar kuch v pass na karo , empty object-->
    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ message: 'No fields to update' });
    }
    
    //finding and updating the folder
    const folder = await Folder.findByIdAndUpdate(req.params.id, updates, {
      new: true,
      runValidators: true,
    });

    if (!folder) return res.status(404).json({ message: 'Folder not found' });

    res.json(folder);
  } catch (error) {
    res.status(500).json({ message: 'Failed to update folder' });
  }
};


//DELETE Folders
const deleteFolder = async (req, res) => {
  try {
    const folder = await Folder.findByIdAndDelete(req.params.id);
    if (!folder) return res.status(404).json({ message: 'Folder not found' });
    res.json({ message: 'Folder deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to delete folder' });
  }
};


// const updateFolder = async (req, res) => {
//   try {
//     const { name, className } = req.body;

//     // name empty string na ho uske liye check
//     if (name !== undefined && name.trim() === '') {
//       return res.status(400).json({
//         message: 'Folder name cannot be empty'
//       });
//     }

//     const folder = await Folder.findByIdAndUpdate(
//       req.params.id,
//       { name,className },
//       {
//         new: true,
//         runValidators: true
//       }
//     );

//     if (!folder) {
//       return res.status(404).json({ message: 'Folder not found' });
//     }

//     res.json(folder);
//   } catch (error) {
//     res.status(500).json({ message: 'Failed to update folder' });
//   }
// };


module.exports={getAllFolders,createFolder,updateFolder,deleteFolder}



