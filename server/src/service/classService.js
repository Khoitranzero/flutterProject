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
      attributes: ["id", "className", "teacherID", "roomName"],
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
    const newClass = await db.Class.create({
      className: data.className,
      roomName: data.roomName,
    });
    const newClassId = newClass.id;
    const newSubjectClass = await db.SubjectClass.create({
      subjectId: data.subjectId,
      classId: newClassId,
    });
    return {
      EM: "Tạo lớp học thành công!!",
      EC: 0,
      DT: newSubjectClass,
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
    // let isUserInClassExist = await checkUserInClassExist(data.id);
    const deletedClassSubject = await db.SubjectClass.destroy({
      where: { classId: data.id },
    });
    const deletedClass = await db.Class.destroy({
      where: { id: data.id },
    });
    const deletedUserInRoom = await db.Room.destroy({
      where: { classId: data.id },
    });

    // if (isUserInClassExist === true) {
    //   await db.User.update({ classId: null }, { where: { classId: data.id } });
    // }

    return {
      EM: "Xóa lớp học thành công!",
      EC: 0,
      DT: {
        deletedClassSubject,
        deletedClass,
        deletedUserInRoom,
      },
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
  try {
    // let isTeacherIdExist = await checkLecturerExistInclass(data.teacherID);
    // if (isTeacherIdExist === true) {
    //   return {
    //     EM: "Lớp học này đã có giáo viên phụ trách",
    //     EC: 2,
    //     DT: [],
    //   };
    // }
    console.log(data);
    const updatedClass = await db.SubjectClass.update(
      {
        teacherId: data.teacherId,
      },
      {
        where: { subjectId: data.subjectId },
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
    // Lấy thông tin lớp từ bảng SubjectClass
    const classes = await db.SubjectClass.findAll({
      attributes: ["id", "classId", "teacherId"],
      where: { teacherId: data.teacherId },
    });
    // Mảng để lưu thông tin của các lớp và số học sinh trong mỗi lớp
    const classesWithTeacherInfo = [];

    // Lặp qua từng lớp
    for (let i = 0; i < classes.length; i++) {
      const classObj = classes[i];
      const classId = classObj.classId;
      const teacherId = classObj.teacherId;

      // Lấy thông tin của lớp từ bảng Class
      const classInfo = await db.Class.findOne({
        where: { id: classId },
        attributes: ["className", "roomName"], // Thêm các trường khác nếu cần
      });

      // Lấy thông tin của giáo viên từ bảng User
      const teacherInfo = await db.User.findOne({
        attributes: ["userId", "username", "address", "phone", "sex"],
        where: { userId: teacherId },
      });

      // Lấy danh sách người học từ bảng Room dựa vào classId
      const roomData = await db.Room.findAll({
        where: { classId: classId },
        attributes: ["userId"], // Lấy danh sách userId trong lớp
      });

      // Mảng để lưu thông tin của người học
      const students = [];

      // Lặp qua danh sách người học và lấy thông tin từ bảng User
      for (let j = 0; j < roomData.length; j++) {
        const userId = roomData[j].userId;
        const studentInfo = await db.User.findOne({
          attributes: ["userId", "username", "address", "phone", "sex"],
          where: { userId: userId },
        });
        // Kiểm tra nếu thông tin học sinh tồn tại thì thêm vào mảng
        if (studentInfo) {
          students.push(studentInfo.toJSON());
        }
      }

      // Đếm số lượng sinh viên trong lớp
      const numberOfStudents = students.length;

      // Tạo đối tượng lớp với thông tin của giáo viên, lớp và danh sách học sinh
      const classWithTeacherInfo = {
        id: classObj.id,
        classId: classId,
        className: classInfo ? classInfo.className : null,
        roomName: classInfo ? classInfo.roomName : null,
        teacherId: teacherId,
        teacherInfo: teacherInfo ? teacherInfo.toJSON() : null,
        students: students, // Danh sách học sinh
        count: numberOfStudents, // Số lượng sinh viên
      };

      // Thêm đối tượng lớp vào mảng classesWithTeacherInfo
      classesWithTeacherInfo.push(classWithTeacherInfo);
    }

    // Trả về kết quả mà không cần bọc nó trong cấu trúc khác
    return {
      EM: "Get classes success",
      EC: 0,
      DT: classesWithTeacherInfo, // Trả về mảng thông tin các lớp
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error fetching classes",
      EC: 1,
      DT: [], // Trả về mảng rỗng trong trường hợp có lỗi
    };
  }
};




const getClassInfoById = async (data) => {
  try {
    // 1. Lấy thông tin của lớp từ bảng Class dựa trên id của lớp
    const classData = await db.Class.findOne({
      where: { id: data.id },
      attributes: ["id", "className", "teacherID", "roomName"],
    });
    const classSubjectData = await db.SubjectClass.findOne({
      where: { classId: data.id },
      attributes: ["teacherId"],
    });
    console.log(classSubjectData);
    const teacherData = await db.User.findOne({
      where: { userId: classSubjectData.teacherId },
      attributes: ["userId", "username", "sex"],
    });
    const roomData = await db.Room.findAll({
      where: { classId: data.id },
      attributes: ["userId"],
    });
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

    // 5. Tạo đối tượng lớp học và danh sách sinh viên
    const classInfo = {
      id: classData.id,
      className: classData.className,
      teacherName: teacherData, // Thêm thông tin của giáo viên
      roomName: classData.roomName,
      students: studentInfoList,
      count: studentInfoList.length,
    };

    return {
      EM: "Get class and student info from room success",
      EC: 0,
      DT: classInfo,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error fetching class and student info from room",
      EC: 1,
      DT: null,
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
  getClassInfoById,
};
