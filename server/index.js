const dotenv= require('dotenv');
const express= require('express');
const cors = require('cors');
const dbconnect = require('./config/dbConnection.js');
const folderRouter = require('./routes/folder.js');
const router = require('./routes/auth.js');
const fileRouter = require('./routes/file.js');
const adminRoutes = require("./routes/volunteer.routes.js");
const otpRoutes = require("./routes/otp.routes");

dotenv.config();
dbconnect();

const app=express();

const PORT=process.env.PORT;

app.use(express.json()); 
app.use(cors());

//  Root route response
app.get('/', (req, res) => {
    res.send('🚀 Server is running successfullyyy!');
});


//================ROUTES=====================
app.use('/api/auth',router);
app.use('/api',folderRouter);
app.use('/api',fileRouter);
app.use('/api/admin', adminRoutes);
app.use("/api/otp", otpRoutes);

//================SERVER======================
app.listen(PORT , ()=>{
    console.log(`server running at port ${PORT}`);
})