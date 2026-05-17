const mongoose= require ('mongoose')

const userSchema = new mongoose.Schema({
  name: { 
    type: String, 
    required: true 
  },
  password: { 
    type: String, 
    required: true 
  },
  phoneNo: {
    type: String,
    //required: true,
    match: [/^[0-9]{10}$/, "Invalid phone number"]
  } ,
  email:{
    type:String,
    required:true
  },
  batch: {
    startYear: { type: Number, required: true, min: 2000, max: 2100 },
    endYear:   { type: Number, required: true, min: 2000, max: 2100 }
  },
  rollNo:{
    type:Number,
    unique:true,
  },
  program:{
    required:true,
    type: String,
    enum: ["DigiXplore","Netritva","Akshar"],
  },
  role: { 
    type: String, 
    default: 'volunteer' 
  }
});

const USER=mongoose.model('User',userSchema);

module.exports=USER;