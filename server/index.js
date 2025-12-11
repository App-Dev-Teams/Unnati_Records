const dotenv= require('dotenv');
const express= require('express');
const cors = require('cors');

const User = require('./models/user.js') ;
const router = require('./routes/auth.js');
const dbconnect = require('./config/dbConnection.js');

dotenv.config();
dbconnect();

const app=express();

const PORT=process.env.PORT;

app.use(express.json()); 
app.use(cors());

app.use('/api/auth',router);

app.listen(PORT , ()=>{
    console.log(`server running at port ${PORT}`);
})