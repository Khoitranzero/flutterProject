//server/src/middleware/JWTAction.js
import  jwt  from "jsonwebtoken";
require("dotenv").config();
//const nonSecurePaths = ['/*'];
const nonSecurePaths = ['/logout', '/login','/register','/',
'/user/getById','/user/read','/user/create','/user/update','/user/delete', '/user/getClassList','/user/getUserNotInClass','/user/updateMultiClass','/user/moveUserFromClass','/user/getByID',
'/class/read','/class/get','/class/create','/class/delete',
'/point/read','/point/create','/point/update', '/point/delete',
'/subject/read','/subject/create','/subject/update', '/subject/delete'];
const createJWT = (payload)=> {

    let key = process.env.JWT_SECRET;
    let token=null;
    try {
        token = jwt.sign(payload, key,{
            expiresIn: process.env.JWT_EXPIRES_IN
        });
        //console.log(token);
    } catch (error) {
        console.log(error);
    }
  return token;
    
}


const verifyToken =(token)=>{
    let key = process.env.JWT_SECRET;
    let decoded=null;

    try {
       decoded = jwt.verify(token, key);
   } catch (error) {
       console.log(error);
   }
   return decoded;
}
const extractToken = (req)=>{
    if(req.headers.Authorization && req.headers.Authorization.split(' ')[0]==='Bearer'){
        return req.headers.Authorization.split(' ')[1];
    }
    return null;
}
const checkUserJWT =(req, res, next) =>{
if (nonSecurePaths.includes(req.path)) return next();
let cookies  = req.cookies;
let tokenFromHeader = extractToken(req);
if((cookies && cookies.jwt) || tokenFromHeader){

    let token = cookies && cookies.jwt ? cookies.jwt :tokenFromHeader;
    let decoded = verifyToken(token);
    if(decoded){
        req.user=decoded;
        req.token=token;
        next();
    }else{
        return res.status(401).json({
            EC: -1,
            DT: '',
            EM: 'Not authenticated the user 1'
          
        })
    }
 } else{
    return res.status(401).json({
        EC: -1,
        DT: '',
        EM: 'Not authenticated the user 2'
    })
}
}
const checkUserPermission = (req, res, next) => {
    if (nonSecurePaths.includes(req.path) || req.path === '/account') return next();
    if (req.user && req.user.getClassName) { 
        let userId = req.user.userId;
        let classNames = req.user.getClassName.classNames;

        let currentUrl = req.path;
        if (!classNames || classNames.length === 0) {
            return res.status(403).json({
                EC: -1,
                EM: 'You don\'t have permission to access this resource',
                DT: ''
            });
        }
        let canAccess = classNames.some(item => item.url === currentUrl);
        if (canAccess === true) {
            next();
        } else {
            return res.status(403).json({
                EC: -1,
                EM: 'You don\'t have permission to access this resource',
                DT: ''
            });
        }
    } else {
        return res.status(401).json({
            EC: -1,
            EM: 'You don\'t have permission to access this resource',
            DT: ''
        });
    }
}
module.exports={
    createJWT,verifyToken,checkUserJWT,checkUserPermission,extractToken
}