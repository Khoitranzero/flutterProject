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
      attributes: ["id", "className", "teacherID"],
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
        teacherInfo: teacherInfo, // Thêm thông tin giáo viên vào đối tượng lớp học
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

const updateClass = async (id, data) => {
  try {
    const updatedClass = await db.Class.update(data, {
      where: { id },
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
    console.log("classID", data);
    let isUserInClassExist = await checkUserInClassExist(data.id);
    console.log("first", isUserInClassExist);

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
    const classes = await db.Class.findAll({
      attributes: ["id", "className", "teacherID"],
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
const checkLecturerExistInclass = async (teacherID) => {
  let lecturersInclass = await db.Class.findOne({
    where: {
      teacherID: teacherID,
    },
  });

  if (lecturersInclass) {
    return true;
  }
  return false;
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
    const updatedClass = await db.Class.update({
      teacherID: data.teacherID
    }, {
      where: { id: data.id },
      transaction: transaction,
    });
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

module.exports = {
  getClass,
  createNewClass,
  updateClass,
  deleteClass,
  countStudentInClass,
  addLecturerIntoClass,
};
