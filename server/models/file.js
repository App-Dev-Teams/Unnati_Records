const mongoose= require('mongoose');
const {ObjectId} = mongoose.Schema.Types ;


const filesSchema= mongoose.Schema({
    //wo jo filename h locally
    originalName:{
        type:String,
    },
    
    //wo name jo frontend pe diya jyega manually
    displayName:{
        type:String,
        required:true,
        trim:true
    },
    
    //pdf,ppt,doc
    type:{
        type:String
    },

    link:{
        type:String,
        required:true,
    },

    folder:{
        type:ObjectId,
        ref:'Folder'
    },

    imagekitFileId: {
      type: String, // ImageKit ka unique fileId
      required: false, // upload time pe add karna h
    },

},{timestamps:true})

const FILES=mongoose.model('Files',filesSchema)

module.exports=FILES;