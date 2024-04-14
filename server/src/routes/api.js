import express from "express";
import apiController from '../controller/apiController';
import userController from '../controller/userController';
import classController from '../controller/classController';
import pointController from '../controller/pointController';
import subjectController from '../controller/subjectController'
import {checkUserJWT,checkUserPermission} from '../middleware/JWTAction';

const router = express.Router();

/**
 * 
 * @param {*} app express app
 * 
 */


const initApiRoutes = (app) => {
 


//rest api
router.all('*',checkUserJWT,checkUserPermission);

router.post("/register",apiController.handleRegister);
router.post("/logout",apiController.handleLogout);
router.post("/login",apiController.handleLogin);
router.get("/account", userController.getUserAccount);

router.get("/user/read", userController.readFunc);
router.post("/user/getById", userController.findOneFunc);
router.get('/user/getClassList', userController.getUserInClass);
router.get('/user/getUserNotInClass', userController.getUserNotInClass);
router.post('/user/getByID', userController.getUserByID);
router.post("/user/create", userController.createFunc);
router.put("/user/update", userController.updateFunc);
router.put("/user/updateMultiClass", userController.updateClassForMultipleUsers);
router.put("/user/moveUserFromClass", userController.moveUserFromClassController);
router.delete("/user/delete", userController.deleteFunc);

router.get("/point/read", pointController.readFunc);
router.post("/point/create",pointController.createFunc);
router.put("/point/update", pointController.updateFunc);
router.delete("/point/delete", pointController.deleteFunc);

 router.get("/class/read", classController.readFunc);
 router.get("/class/get", classController.getClassListAndStudent);
router.post("/class/create", classController.createFunc);
router.put("/class/update", classController.updateFunc);
router.delete("/class/delete", classController.deleteFunc);

 router.get("/subject/read", subjectController.readFunc);
router.post("/subject/create", subjectController.createFunc);
router.put("/subject/update", subjectController.updateFunc);
router.delete("/subject/delete", subjectController.deleteFunc);
    return app.use("/api/v1/", router);
}
export default initApiRoutes;