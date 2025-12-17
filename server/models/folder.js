const mongoose= require('mongoose');

const folderSchema= mongoose.Schema({
    //ms word, ms excel, canva
    name:{
        type:String,
        required:true,
        trim:true
    },
    className:{
        type:String,        
    }

},{timestamps:true})

const FOLDER=mongoose.model('Folder',folderSchema)

module.exports=FOLDER;