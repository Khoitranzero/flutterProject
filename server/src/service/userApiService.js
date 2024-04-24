//src/service/userApiService.js
// import { where } from "sequelize";
const { Vonage } = require('@vonage/server-sdk')
// import Nexmo from "nexmo";
const { Op, where } = require("sequelize");
import db from "../models";
require("dotenv").config();
import {
  checkUserIdExist,
  checkPhoneExist,
} from "../service/loginRegisterService";
import bcrypt from "bcryptjs";
const salt = bcrypt.genSaltSync(10);
const hashUserPassword = (userPassword) => {
  let hashPassword = bcrypt.hashSync(userPassword, salt);
  return hashPassword;
};
const getOneUser = async (userId) => {
  try {
    let user = await db.User.findOne({
      where: { userId: userId }, approval: {
        [Op.or]: [1] 
      },
      attributes: ["userId", "username", "address", "sex", "phone", "classId"],
      include: { model: db.Class, attributes: ["className"] },
    });
    if (user) {
      return {
        EM: "Get one user success",
        EC: 0,
        DT: user,
      };
    } else {
      return {
        EM: " student not exist",
        EC: 2,
        DT: [],
      };
    }
  } catch (error) {
    console.log(e);
    return {
      EM: "get data success",
      EC: 1,
      DT: [],
    };
  }
};
const getAllUser = async () => {
  try {
    const users = await db.User.findAll({
      where: { approval: {
        [Op.or]: [1] 
      }, }, 
      attributes: ["userId", "username", "address", "phone", "sex", "classId"],
      include: { model: db.Class, attributes: ["className"] },
    });
    // console.log( users);
    if (users) {
      return {
        EM: "get data success",
        EC: 0,
        DT: users,
      };
    } else {
      return {
        EM: "get data success",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};
const getStudentApprovedList = async () => {
  try {
    const users = await db.User.findAll({
      attributes: ["userId", "username", "address", "phone", "sex", "classId","password","approval"],
      include: { model: db.Class, attributes: ["className"] },
      where: {
        approval: {
          [Op.or]: [0] 
        }
      }
    });
    if (users) {
      return {
        EM: "get data success",
        EC: 0,
        DT: users,
      };
    } else {
      return {
        EM: "get data success",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};
const getLecturerApprovedList = async () => {
  try {
    const users = await db.User.findAll({
      attributes: ["userId", "username", "address", "phone", "sex", "classId","password","approval"],
      include: { model: db.Class, attributes: ["className"] },
      where: {
        approval: {
          [Op.or]: [0] 
        }
      }
    });
    if (users) {
      return {
        EM: "get data success",
        EC: 0,
        DT: users,
      };
    } else {
      return {
        EM: "get data success",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};
const getListAllLecturer = async () => {
  try {
    const lecturers = await db.User.findAll({
      attributes: ["userId", "username", "address", "phone", "sex", "classId"],
      include: { model: db.Class, attributes: ["className"] },
      where: {
        userId: {
          [Op.like]: "%gv%",
         
        },
        approval: {
          [Op.or]: [1] 
        },
      },
    });
    // console.log( users);
    if (lecturers) {
      return {
        EM: "get data success",
        EC: 0,
        DT: lecturers,
      };
    } else {
      return {
        EM: "get data success",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};

const getUserWithPagination = async (page, limit) => {
  try {
    let offset = (page - 1) * limit;
    const { count, rows } = await db.User.findAndCountAll({
      offset: offset,
      limit: limit,
      attributes: ["userId", "username", "address", "phone", "sex", "classId"],
      include: { model: db.Class, attributes: ["className"] },
      order: [["userId", "DESC"]],
    });

    let totalPages = Math.ceil(count / limit);
    let data = {
      totalRows: count,
      totalPages: totalPages,
      users: rows,
    };

    return {
      EM: "fetch ok",
      EC: 0,
      DT: data,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};

const createNewUser = async (data) => {
  try {
    let isUserIdExist = await checkUserIdExist(data.userId);
    if (isUserIdExist === true) {
      return {
        EM: "MSSV already exist",
        EC: 1,
        DT: "userId",
      };
    }
    let isPhoneExist = await checkPhoneExist(data.phone);
    if (isPhoneExist === true) {
      return {
        EM: "The phone number already exist",
        EC: 1,
        DT: "phone",
      };
    }
    //hash user password
    let hashPassword = hashUserPassword(data.password);
    //create new user
    await db.User.create({ ...data, password: hashPassword });
    return {
      EM: "create ok",
      EC: 0,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "something wrong with service",
      EC: 1,
      DT: [],
    };
  }
};
const updateUser = async (data) => {
  console.log("data", data);
  let transaction;
  let prefix;
  if (data.role === "Giảng viên") {
    prefix = "gv";
  } else if (data.role === "Sinh viên") {
    prefix = "dh";
  }
  try {
    transaction = await db.sequelize.transaction();

    // Kiểm tra xem data đã có userId hay chưa
    if (!data.userId) {
      // Tạo userId ngẫu nhiên dựa trên role
      const randomNumber = Math.floor(10000000 + Math.random() * 90000000);
      const generatedUserId = `${prefix}${randomNumber}`;

      // Kiểm tra xem userId đã tồn tại hay chưa
      let isUserIdExist = await checkUserIdExist(generatedUserId);
      if (isUserIdExist === true) {
        return {
          EM: "MSSV này đã được sử dụng, vui lòng nhập đúng MSSV đã được cấp",
          EC: 1,
        };
      }

      // Cập nhật userId vào data
      data.userId = generatedUserId;
    }

    // Cập nhật thông tin người dùng
    const updatedUser = await db.User.update(
      {
        userId: data.userId, // userId sẽ không thay đổi nếu đã tồn tại
        username: data.username,
        address: data.address,
        sex: data.sex,
      },
      { where: { phone: data.phone }, transaction }
    );

    if (!updatedUser) {
      throw new Error("User not found");
    }

    await transaction.commit();
    return {
      EM: "Cập nhật thông tin người dùng thành công !!!",
      EC: 0,
      DT: updatedUser,
    };
  } catch (error) {
    if (transaction) await transaction.rollback();

    console.error(error);
    return {
      EM: "Error updating user",
      EC: 1,
      DT: [],
    };
  }
};

// const updateUser = async (data) => {
//   console.log("data",data)
//   let transaction;
//   let hashPassword = hashUserPassword(data.password);
//    let prefix;
//     if(data.role === "Giảng viên") {
//       prefix = "gv";
//     } else if (data.role === "Sinh viên") {
//       prefix = "dh";
//     }
//     const randomNumber = Math.floor(10000000 + Math.random() * 90000000);
//     const generatedUserId = `${prefix}${randomNumber}`;

//     let isUserIdExist = await checkUserIdExist(generatedUserId);
//     if (isUserIdExist === true) {
//       return {
//         EM: "MSSV này đã được sử dụng, vui lòng nhập đúng MSSV đã được cấp",
//         EC: 1,
//       };
//     }
//   try {
//     transaction = await db.sequelize.transaction();
//     if (data.userId) {
//     // if (data.userId.includes("gv")) {
//       // bỏ cái này để không cập nhật bên classId bên user
//       const updatedUser = await db.User.update(
//         {
//           userId: generatedUserId,
//           username: data.username,
//           address: data.address,
//           sex: data.sex,
//           password:hashPassword
//           // Password ở đây
//         },
//         { where: { phone: data.phone }, transaction }
//       );
//       // const updatedClass = await db.Class.update(
//       //   {
//       //     teacherID: data.userId,
//       //   },
//       //   {
//       //     where: { className: data.className },
//       //     transaction: transaction,
//       //   }
//       // );

//       if (!updatedUser) {
//         throw new Error("User not found");
//       }

//       await transaction.commit();
//       return {
//         EM: "Cập nhật thông tin của sinh viên và lớp thành công !!!",
//         EC: 0,
//         DT: updatedUser,
//       };
//     } else {
//       // let classInfo = await db.Class.findOne({
//       //   where: { className: data.className },
//       //   transaction,
//       // });

//       // if (!classInfo) {
//       //   classInfo = await db.Class.create(
//       //     { className: data.className },
//       //     { transaction }
//       //   );
//       // }

//       const updatedUser = await db.User.update(
//         {
//           username: data.username,
//           address: data.address,
//           sex: data.sex,
//           password:hashPassword
//           // Password ở đây
//         },
//         { where: { phone: data.phone }, transaction }
//       );
//       if (updatedUser[0] === 0) {
//         throw new Error("User not found");
//       }

//       await transaction.commit();
//       return {
//         EM: "Cập nhật thông tin của người dùng thành công !!!",
//         EC: 0,
//         DT: updatedUser,
//       };
//     }
//   } catch (error) {
//     if (transaction) await transaction.rollback();

//     console.error(error);
//     return {
//       EM: "Error updating user and class",
//       EC: 1,
//       DT: [],
//     };
//   }
// };

const removeTeacherOutOfClass = async (data) => {
  let transaction;
  try {
    transaction = await db.sequelize.transaction();

    const updatedUser = await db.User.update(
      {
        classId: null,
      },
      { where: { userId: data.userId }, transaction }
    );
    const updatedClass = await db.Class.update(
      {
        teacherID: null,
      },
      {
        where: { id: data.id },
        transaction: transaction,
      }
    );

    if (updatedUser[0] === 0 || !updatedClass) {
      throw new Error("User not found");
    }

    await transaction.commit();
    return {
      EM: "Cập nhật giáo viên phụ trách thành công !!!",
      EC: 0,
      DT: updatedUser,
    };
  } catch (error) {
    if (transaction) await transaction.rollback();

    console.error(error);
    return {
      EM: "Error updating user and class",
      EC: 1,
      DT: [],
    };
  }
};

const updateOneUser = async (userId, classId) => {
  try {
    const updatedUser = await db.User.update(
      {
        classId: classId,
      },
      { where: { userId: userId } }
    );
    return {
      EM: "Cập nhật lớp của sinh viên thành công !!!",
      EC: 0,
      DT: updatedUser,
    };
  } catch (error) {
    return {
      EM: "Error updating user and class 1",
      EC: 1,
      DT: [],
    };
  }
};

const updateClassForUser = async (listUserId, classId) => {
  try {
    for (const userItem of listUserId) {
      await updateOneUser(userItem, classId);
    }
    return {
      EM: "Cập nhật thông tin cho lớp thành công",
      EC: 1,
      DT: [],
    };
  } catch (error) {
    return {
      EM: "Error updating user and class 2",
      EC: 1,
      DT: [],
    };
  }
};
const MoveUserFromClass = async (listUserId) => {
  try {
    for (const userItem of listUserId) {
      await updateOneUser(userItem, null);
    }
    return {
      EM: "Xóa sinh viên ra khỏi lớp thành công",
      EC: 1,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error updating user and class 3",
      EC: 1,
      DT: [],
    };
  }
};
const deleteUser = async (userId) => {
  try {
    let user = await db.User.findOne({
      where: { userId: userId },
    });
    if (user) {
      await user.destroy();
      return {
        EM: "Xóa sinh viên thành công",
        EC: 0,
        DT: [],
      };
    } else {
      return {
        EM: " student not exist",
        EC: 2,
        DT: [],
      };
    }
  } catch (error) {
    console.log(e);
    return {
      EM: "get data success",
      EC: 1,
      DT: [],
    };
  }
};
const getListUserFromClass = async () => {
  try {
    let userCount = await db.User.findAll({
      where : { approval: {
        [Op.or]: [1] 
      },},

      attributes: ["userId", "username", "address", "sex", "phone", "classId"],
      include: { model: db.Class, attributes: ["className"] },
    });
    let count = userCount.length;
    if (count > 0) {
      return {
        EM: "Get list user from class success",
        EC: 0,
        DT: {
          userInClass: userCount,
          count: count,
        },
      };
    } else {
      return {
        EM: "No user found in the class",
        EC: 0,
        DT: {},
      };
    }
  } catch (e) {
    return {
      EM: "Error from get list student in class",
      EC: 1,
      DT: [],
    };
  }
};
const filterStudentNotInClass = async () => {
  try {
    const users = await db.User.findAll({
      where: { userId: { [Op.like]: "%dh%" }, classId: null , approval: {
        [Op.or]: [1] 
      },},
      attributes: ["userId", "username", "address", "phone", "sex"],
    });
    if (users) {
      return {
        EM: "get data success",
        EC: 0,
        DT: users,
      };
    } else {
      return {
        EM: "get data failed",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};

const filterTeacherNotInClass = async () => {
  try {
    const users = await db.User.findAll({
      where: { userId: { [Op.like]: "%gv%" } , approval: {
        [Op.or]: [1] 
      },},
      attributes: ["userId", "username", "address", "phone", "sex"],
    });
    if (users) {
      return {
        EM: "get data success",
        EC: 0,
        DT: users,
      };
    } else {
      return {
        EM: "get data failed",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};
const getOneUserByID = async (userId) => {
  try {
    const user = await db.User.findOne({
      where: {
        userId: userId,
        approval: {
          [Op.or]: [1] 
        },
      },
    });
    console.log("use check : ",user);
    if (user) {
      return {
        EM: "get data success",
        EC: 0,
        DT: user,
      };
    } else {
      return {
        EM: "get data failed",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};
const getOneUserByPhone = async (data) => {
  try {
    console.log("phone",data.phone)

    const user = await db.User.findOne({
      where: {
        [Op.or]: [
           { userId: data.phone },
          { phone: data.phone },
        ],
      },
    });
// console.log("user by phone",user)
    if (user) {
      return {
        EM: "Lấy dữ liệu thành công",
        EC: 0,
        DT: user,
      };
    } else {
      return {
        EM: "Không tìm thấy người dùng với số điện thoại này",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    return {
      EM: "Lỗi từ máy chủ",
      EC: 1,
      DT: [],
    };
  }
};

const vonage = new Vonage({
  apiKey: '7dc3bdee',
  apiSecret: 'FG17czoyB1pzXseD'
});
const sendSMS = async (to, message) => {
  const from = "84907267362"
   //to = "84334323968"
  //to = "84907267362"

  try {
    const updatedUser = await db.User.update(
      {
        approval: 1,
      },
      { where: { phone: to } }
    );
    const text=message;
    console.log("text message", text)
    const response = 1
    //await vonage.sms.send({ to, from, text });
    console.log('Message sent successfully');
    console.log(response);
  } catch (error) {
    console.error('There was an error sending the message:');
    console.error(error);

    // If available, log the response from Vonage
    if (error.response) {
      console.error('Response from Vonage:');
      console.error(error.response);
    }
  }
};

module.exports = {
  getAllUser,
  createNewUser,
  updateUser,
  deleteUser,
  getUserWithPagination,
  getOneUser,
  getListUserFromClass,
  filterStudentNotInClass,
  updateClassForUser,
  MoveUserFromClass,
  getOneUserByID,
  getOneUserByPhone,
  getListAllLecturer,
  filterTeacherNotInClass,
  removeTeacherOutOfClass,
  getLecturerApprovedList,
  getStudentApprovedList,
  sendSMS
};
