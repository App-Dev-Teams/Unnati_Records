const mongoose= require('mongoose');
const {ObjectId} = mongoose.Schema.Types ;


const userAttendanceSchema= mongoose.Schema({
    userId:{
        type:ObjectId,
        ref:'User',
        required: true,
        unique: true
    },
    present:[{type:Date}],
    absent:[{type:Date}],
    cancelled:[{type:Date}],

},{timestamps:true})

const UserAttendance=mongoose.model('UserAttendance',userAttendanceSchema)

module.exports=UserAttendance;