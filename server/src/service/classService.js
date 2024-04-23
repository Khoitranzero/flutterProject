import { Sequelize, where } from "sequelize";
import db from "../models";
const checkClassNameExist = async (className) => {
  let classname = await db.Class.findOne({
    where: {
      className: className,
    },
  });

  if (classname) {
    return true;
  }
  return false;
};
const checkUserInClassExist = async (classId) => {
  let userInClass = await db.User.findOne({
    where: {
      classId: classId,
    },
  });

  if (userInClass) {
    return true;
  }
  return false;
};
const getClass = async () => {
  try {
    const classes = await db.Class.findAll({
      attributes: ["id", "className", "teacherID", "subjectID"],
      include: { model: db.User, attributes: ["username"] },
    });
    const classesWithTeacherInfo = [];
    for (let i = 0; i < classes.length; i++) {
      const classObj = classes[i];
      const id = classObj.dataValues.id;
      const className = classObj.dataValues.className;
      const teacherID = classObj.dataValues.teacherID;

      // Truy vấn thông tin giáo viên
      const teacherInfo = await db.User.findOne({
        attributes: ["username", "address", "phone", "sex"],
        where: { userId: teacherID },
      });

      const classWithTeacher = {
        id: id,
        className: className,
        teacherID: teacherID,
        teacherInfo: teacherInfo,
      };
      classesWithTeacherInfo.push(classWithTeacher);
    }

    return {
      EM: "Get classes success",
      EC: 0,
      DT: classesWithTeacherInfo,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error fetching classes",
      EC: 1,
      DT: [],
    };
  }
};

const createNewClass = async (data) => {
  try {
    console.log("classanme", data);
    let isClassNameExist = await checkClassNameExist(data.className);
    console.log("first", isClassNameExist);
    if (isClassNameExist === true) {
      return {
        EM: "Lớp học này đã tồn tại",
        EC: 2,
        DT: [],
      };
    }
    const newClass = await db.Class.create(data);
    return {
      EM: "Tạo lớp học thành công!!",
      EC: 0,
      DT: newClass,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error creating class",
      EC: 1,
      DT: [],
    };
  }
};

const updateClass = async (data) => {
  try {
    console.log(data);
    const updatedClass = await db.Class.update(data, {
      where: { id: data.id },
    });
    return {
      EM: "Cập nhật thông tin lớp thành công",
      EC: 0,
      DT: updatedClass,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error updating class",
      EC: 1,
      DT: [],
    };
  }
};

const deleteClass = async (data) => {
  try {
    let isUserInClassExist = await checkUserInClassExist(data.id);
    const deletedClass = await db.Class.destroy({
      where: { id: data.id },
    });

    if (isUserInClassExist === true) {
      await db.User.update({ classId: null }, { where: { classId: data.id } });
    }

    return {
      EM: "Xóa lớp học thành công!",
      EC: 0,
      DT: deletedClass,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error deleting class",
      EC: 1,
      DT: [],
    };
  }
};

const countStudentInClass = async () => {
  try {
    // Lấy danh sách tất cả các lớp từ bảng Class
    const classData = await db.Class.findAll({
      attributes: ["id", "className", "teacherID", "roomName"],
    });

    // Mảng để lưu thông tin về các lớp học và sinh viên
    const classInfoList = [];

    // Lặp qua từng lớp học từ bảng Class
    for (const classRow of classData) {
      const classId = classRow.id;

      // Lấy danh sách các userId của sinh viên trong lớp từ bảng Room
      const roomData = await db.Room.findAll({
        where: { classId: classId },
        attributes: ["userId"],
      });

      // Lấy thông tin chi tiết của từng sinh viên từ bảng User
      const studentInfoList = [];
      for (const roomRow of roomData) {
        const userId = roomRow.userId;
        const userInfo = await db.User.findOne({
          where: { userId: userId },
          attributes: ["userId", "username", "address", "sex", "phone"],
        });
        if (userInfo) {
          studentInfoList.push(userInfo.toJSON());
        }
      }

      // Tạo đối tượng lớp học và thêm vào mảng kết quả
      const classInfo = {
        classId: classId,
        className: classRow.className,
        teacherID: classRow.teacherID,
        roomName: classRow.roomName,
        students: studentInfoList,
      };
      classInfoList.push(classInfo);
    }

    return {
      EM: "Get class and student info from room success",
      EC: 0,
      DT: classInfoList,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error fetching class and student info from room",
      EC: 1,
      DT: [],
    };
  }
};


const addLecturerIntoClass = async (data) => {
  let transaction;
  try {
    transaction = await db.sequelize.transaction();

    // let isTeacherIdExist = await checkLecturerExistInclass(data.teacherID);
    // if (isTeacherIdExist === true) {
    //   return {
    //     EM: "Lớp học này đã có giáo viên phụ trách",
    //     EC: 2,
    //     DT: [],
    //   };
    // }
    const updatedClass = await db.Class.update(
      {
        teacherID: data.teacherID,
      },
      {
        where: { id: data.id },
        transaction: transaction,
      }
    );
    // const updateUser = await db.User.update(
    //   {
    //     classId: data.id,
    //   },
    //   {
    //     where: { userId: data.teacherID },
    //     transaction: transaction,
    //   }
    // );
    await transaction.commit();
    if (updatedClass) {
      return {
        EM: "Thêm giáo viên phụ trách thành công",
        EC: 0,
        DT: updatedClass,
      };
    } else if (updatedClass) {
      return {
        EM: "Lỗi thêm giáo viên phụ trách",
        EC: 0,
        DT: updatedClass,
      };
    }
  } catch (error) {
    // Nếu có lỗi, rollback transaction
    if (transaction) await transaction.rollback();

    console.log(error);
    return {
      EM: "Lỗi thêm giáo viên phụ trách!!",
      EC: 1,
      DT: [],
    };
  }
};

const filterClassByTeacherID = async (data) => {
  try {
    const classes = await db.Class.findAll({
      attributes: ["id", "className", "teacherID"],
      where: { teacherID: data.teacherID }, // Thêm điều kiện lọc ở đây
      include: {
        model: db.User,
        attributes: [
          "userId",
          "username",
          "address",
          "sex",
          "phone",
          "classId",
        ],
      },
    });

    const classesWithTeacherInfo = [];

    for (let i = 0; i < classes.length; i++) {
      const classObj = classes[i];
      const id = classObj.dataValues.id;
      const className = classObj.dataValues.className;
      const teacherID = classObj.dataValues.teacherID;
      const teacherInfo = await db.User.findOne({
        attributes: ["userId", "username", "address", "phone", "sex"],
        where: { userId: teacherID },
      });
      const students = classObj.Users.map((user) => ({
        userId: user.userId,
        username: user.username,
        address: user.address,
        sex: user.sex,
        phone: user.phone,
        classId: user.classId,
      }));
      const classWithTeacher = {
        id: id,
        className: className,
        teacherID: teacherID,
        teacherInfo: teacherInfo ? teacherInfo.toJSON() : null,
        Users: students,
      };
      classesWithTeacherInfo.push(classWithTeacher);
    }

    return {
      EM: "Get classes success",
      EC: 0,
      DT: classesWithTeacherInfo,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error fetching classes",
      EC: 1,
      DT: [],
    };
  }
};

module.exports = {
  getClass,
  createNewClass,
  updateClass,
  deleteClass,
  countStudentInClass,
  addLecturerIntoClass,
  filterClassByTeacherID,
};
