//server/src/routers/api.js
import express from "express";
import apiController from '../controller/apiController';
import userController from '../controller/userController';
import classController from '../controller/classController';
import pointController from '../controller/pointController';
import subjectController from '../controller/subjectController';
import classSubjectController from '../controller/classSubjectController';
import {checkUserJWT,checkUserPermission} from '../middleware/JWTAction';
import roomController from '../controller/roomController'
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
router.post('/user/getByPhone', userController.getUserByPhone);
router.post("/user/create", userController.createFunc);
router.put("/user/update", userController.updateFunc);
router.put("/user/updateMultiClass", userController.updateClassForMultipleUsers);
router.put("/user/moveUserFromClass", userController.moveUserFromClassController);
router.delete("/user/delete", userController.deleteFunc);
router.get("/user/getTeacherNotInClass", userController.getTeacherNotInClass);
router.put("/user/removeTeacherOutOfClass", userController.removeTeacerOutClass);
router.get("/user/getStudentApprovedList", userController.getStudentApprovedList);
router.post("/user/sendUserInformation", userController.sendUserInformation);
router.get("/user/getLecturer", userController.getListLecturer);


router.get("/classSubject/read", classSubjectController.readFunc);

router.get("/room/read", roomController.readFunc);

router.get("/point/read", pointController.readFunc);
router.post("/point/create",pointController.createFunc);
router.put("/point/update", pointController.updateFunc);
router.delete("/point/delete", pointController.deleteFunc);

 router.get("/class/read", classController.readFunc);
 router.get("/class/get", classController.getClassListAndStudent);
router.post("/class/create", classController.createFunc);
router.put("/class/update", classController.updateFunc);
router.delete("/class/delete", classController.deleteFunc);
router.put("/class/addTeacher", classController.addTeacherIntoClass);
router.post("/class/getClassByTeacherID", classController.getClassByTeacherID)

 router.get("/subject/read", subjectController.readFunc);
router.post("/subject/create", subjectController.createFunc);
router.put("/subject/update", subjectController.updateFunc);
router.delete("/subject/delete", subjectController.deleteFunc);
    return app.use("/api/v1/", router);
}
export default initApiRoutes;