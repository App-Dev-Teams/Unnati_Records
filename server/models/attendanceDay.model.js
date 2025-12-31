const mongoose= require('mongoose');
const {ObjectId} = mongoose.Schema.Types ;


const attendanceDaySchema= mongoose.Schema({
    date:{
        type:Date,
        required:true,
    },
    presentUserId:[{
        type:ObjectId,
        ref:'User',
    }],
    absentUserId:[{
        type:ObjectId,
        ref:'User',
    }],
    cancelledUserId:[{
        type:ObjectId,
        ref:'User',
    }],

},{timestamps:true})

const AttendanceDay=mongoose.model('AttendanceDay',attendanceDaySchema)

module.exports=AttendanceDay;