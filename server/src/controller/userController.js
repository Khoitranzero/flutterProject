//src/controller/userController.js
import userApiService from "../service/userApiService";

const findOneFunc = async (req, res) => {
  try {
    let data = await userApiService.getOneUser(req.body.userId);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};

const readFunc = async (req, res) => {
  try {
    // if(req.query.page && req.query.limit){
    //     let page=req.query.page;
    //     let limit= req.query.limit;

    //     let data=await userApiService.getUserWithPagination(+page,+limit);
    //     return res.status(200).json({
    //         EM : data.EM,
    //         EC: data.EC,
    //         DT: data.DT

    //     })
    // }
    // else{
    let data = await userApiService.getAllUser();
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
    // }
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const createFunc = async (req, res) => {
  try {
    let data = await userApiService.createNewUser(req.body);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const updateFunc = async (req, res) => {
  try {
    console.log("update", req.body);
    let data = await userApiService.updateUser(req.body);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};

const deleteFunc = async (req, res) => {
  try {
    let data = await userApiService.deleteUser(req.body.userId);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const getUserAccount = async (req, res) => {
  return res.status(200).json({
    EM: "ok",
    EC: 0,
    DT: {
      access_token: req.token,
      getClass: req.user.getClass,
      userId: req.user.userId,
      username: req.user.username,
    },
  });
};
const getUserInClass = async (req, res) => {
  try {
    let data = await userApiService.getListUserFromClass(req.body.classId);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const getUserNotInClass = async (req, res) => {
  try {
    let data = await userApiService.filterStudentNotInClass();
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
    // }
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const updateClassForMultipleUsers = async (req, res) => {
  try {
    const { listUserId, classId } = req.body;
    let data = await userApiService.updateClassForUser(listUserId, classId);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const moveUserFromClassController = async (req, res) => {
  try {
    const { listUserId } = req.body;
    let data = await userApiService.MoveUserFromClass(listUserId);
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};

const getUserByID = async (req, res) => {
  try {
    let data = await userApiService.getOneUserByID(req.body);
    if (data) {
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
    }
  } catch (e) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const getListLecturer = async (req,res) => {
  try {
    let data = await userApiService.getListAllLecturer();
    if (data) {
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
    }
  } catch (e) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
}
module.exports = {
  readFunc,
  createFunc,
  updateFunc,
  deleteFunc,
  getUserAccount,
  findOneFunc,
  getUserInClass,
  getUserNotInClass,
  updateClassForMultipleUsers,
  moveUserFromClassController,
  getUserByID,
  getListLecturer
};
