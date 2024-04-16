//src/controller/lasController.js
import classService from "../service/classService";
const readFunc = async (req, res) => {
  try {
    let data = await classService.getClass();

    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: data.DT,
    });
  } catch (error) {
    console.log(e);
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
const createFunc = async (req, res) => {
  try {
    let data = await classService.createNewClass(req.body);
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
    let data = await classService.updateClass(req.body);
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
    let data = await classService.deleteClass(req.body);
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
const getClassListAndStudent = async (req, res) => {
  try {
    let data = await classService.countStudentInClass();
    let newDataWithCount = data.DT.map((classItem) => {
      let count = classItem.Users.length;
      return { ...classItem, count: count };
    });
    return res.status(200).json({
      EM: data.EM,
      EC: data.EC,
      DT: newDataWithCount,
    });
  } catch (e) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};
module.exports = {
  readFunc,
  createFunc,
  updateFunc,
  deleteFunc,
  getClassListAndStudent,
};
