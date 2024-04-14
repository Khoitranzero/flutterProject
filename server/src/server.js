import express from "express";
import configViewEngine from "./config/viewEngine";
import bodyParser from 'body-parser';
import initApiRoutes from "./routes/api";
import configCors from "./config/cors";
import connection from "./config/conectDB";
import {createJWT, verifyToken } from './middleware/JWTAction';
import cookieParse from 'cookie-parser';
require("dotenv").config();
 const app = express();
 const PORT = process.env.PORT || 8080;



configCors(app);
 configViewEngine(app);
 app.use(bodyParser.json());
 app.use(bodyParser.urlencoded({ extended: true }));
 
//config cookie parser
app.use(cookieParse());

//connection();

 //initWebRoutes(app);
 initApiRoutes(app);
 app.use((req,res)=>{
   return res.send('404 not found')
 })

 app.listen(PORT, ()=>{
    console.log("jwt backend port = "+PORT);
 })