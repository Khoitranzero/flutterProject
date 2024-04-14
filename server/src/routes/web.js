import express from "express";
import homeController from '../controller/homeController';
import apiController from '../controller/apiController';

const router = express.Router();

/**
 * 
 * @param {*} app express app
 * 
 */
const initWebRoutes = (app) => {
    router.get("/", homeController.handleHelloWorld);
    router.get("/user", homeController.handleUserPage);
    router.post("/users/create-user", homeController.handlCreateNewUser);
    router.post("/delete-user/:userId", homeController.handleDeleteUser);
    router.get("/update-user/:userId",homeController.getUpdateUserPage);
    router.post("/users/update-user", homeController.handlUpdateUser);


//rest api
router.get("/api/test-api", apiController.testApi);

   return app.use("/", router);
}
export default initWebRoutes;