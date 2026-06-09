const mongoose= require('mongoose');
const messageschema = mongoose.Schema({
    doubtId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Doubt',
        required: true,
    },
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    senderRole: {
        type: String,
        required: true,
    },
    message: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    updatedAt: {
        type: Date,
        default: Date.now
    }



});
module.exports = mongoose.model("DoubtMessage", messageschema);