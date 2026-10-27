const mongoose = require('mongoose');

const liveDoubtSessionSchema = new mongoose.Schema({
    studentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'STUDENT',
        required: true,
    },
    studentName: { 
        type: String, 
        required: true 
    },
    studentClass: { 
        type: String, 
        default: 'N/A' 
    },
    subject: { 
        type: String, 
        required: true 
    },
    topic: { 
        type: String, 
        required: true, 
        trim: true 
    },
    status: {
        type: String,
        enum: ['waiting', 'scheduled', 'ongoing', 'completed', 'cancelled', 'expired'],
        default: 'waiting'
    },
    // Scheduling details set by the Lead
    scheduledStartTime: {
        type: Date,
        default: null
    },
    scheduledEndTime: {
        type: Date,
        default: null
    },
    scheduledBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        default: null
    },
    scheduledByName: {
        type: String,
        default: null
    },
    scheduledByRole: {
        type: String,
        default: null
    },
    // Acceptance / ongoing details
    acceptedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        default: null
    },
    acceptedByName: { 
        type: String, 
        default: null 
    },
    channelName: { 
        type: String, 
        required: true 
    },
    requestedAt: { 
        type: Date, 
        default: Date.now 
    },
    startedAt: { 
        type: Date, 
        default: null 
    },
    endedAt: { 
        type: Date, 
        default: null 
    },
    durationSeconds: { 
        type: Number, 
        default: 0 
    }
}, { timestamps: true });

module.exports = mongoose.model('LiveDoubtSession', liveDoubtSessionSchema);
