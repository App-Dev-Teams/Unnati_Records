const mongoose= require('mongoose');
const doubtschema = mongoose.Schema({
    title: {
        type:String,
        required:true,
        trim:true
    },
    studentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    subject: {
        type:String,
    },
    status: {
        type: String,
        enum: ['open', 'closed'],
        default: 'open'
    },
    resolvedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',

    },
    resolvedAt: {
        type: Date,
        default:null,
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    updatedAt: {
        type: Date,
        default: Date.now
    }

})

module.exports = mongoose.model("Doubt", doubtschema);
