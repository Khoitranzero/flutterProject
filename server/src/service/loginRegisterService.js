//src/service/loginRegisterService.js
import db from "../models";
require("dotenv").config();
import { Op } from "sequelize";
import bcrypt from "bcryptjs";
import { getClassName } from "./JWTService";
import { createJWT } from "../middleware/JWTAction";
const salt = bcrypt.genSaltSync(10);
const hashUserPassword = (userPassword) => {
  let hashPassword = bcrypt.hashSync(userPassword, salt);
  return hashPassword;
};
const checkUserIdExist = async (userId) => {
  let user = await db.User.findOne({
    where: { userId: userId },
  });

  if (user) {
    return true;
  }
  return false;
};

const checkPhoneExist = async (userPhone) => {
  let user = await db.User.findOne({
    where: { phone: userPhone },
  });

  if (user) {
    return true;
  }
  return false;
};

const registerNewUser = async (rawUserData) => {
  try {
    let isPhoneExist = await checkPhoneExist(rawUserData.phone);
    if (isPhoneExist === true) {
      return {
        EM: "Số điện thoại đã được sử dụng, vui lòng nhập số điện thoại khác",
        EC: 1,
      };
    }

    // Sử dụng số điện thoại làm mật khẩu
    let hashPassword = hashUserPassword(rawUserData.phone);

    await db.User.create({
      username: rawUserData.username,
      address: rawUserData.address,
      phone: rawUserData.phone,
      sex: rawUserData.sex,
      password: hashPassword,
      approval: 0,
    });

    return {
      EM: "Đăng ký thành công",
      EC: 0,
    };
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: -2,
    };
  }
};

const chekPassword = (inputPassword, hashPassword) => {
  return bcrypt.compareSync(inputPassword, hashPassword);
};
const handleUserLogin = async (rawData) => {
  try {
    let user = await db.User.findOne({
      where: {
        [Op.or]: [
           { userId: rawData.valueLogin },
          { phone: rawData.valueLogin },
        ],
      },
    });

    if (user) {
      console.log("first",rawData.password)
      console.log("first",user.password)
      let isCorrectPassword = chekPassword(rawData.password, user.password);

      if (isCorrectPassword === true) {
        // Tạo JWT và trả về kết quả đăng nhập thành công
        let payload = {
          userId: user.userId,
          username: user.username,
        };
        let token = createJWT(payload);
        return {
          EM: "Đăng nhập thành công",
          EC: 0,
          DT: {
            access_token: token,
            userId: user.userId,
            username: user.username,
          },
        };
      }
    }

    console.log("Thông tin đăng nhập không đúng");
    return {
      EM: "Thông tin đăng nhập chưa đúng, xin vui lòng nhập lại!",
      EC: 1,
      DT: "",
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "error from server",
      EC: -2,
    };
  }
};
const changePassword = async (rawUserData) => {
  try {
    let user = await db.User.findOne({
      where: {
        userId: rawUserData.userId,
      },
    });
console.log("first",rawUserData)
    if (user) {
      // Compare the provided current password with the stored hashed password
      let isCorrectPassword = chekPassword(
      
        rawUserData.password,
        user.password,
      );
console.log("isCorrectPassword",isCorrectPassword)
      if (isCorrectPassword) {
        // If the current password matches, proceed with updating the password
        let hashPassword = hashUserPassword(rawUserData.newpassword);

        const updatedUser = await db.User.update(
          {
            password: hashPassword,
          },
          { where: { userId: rawUserData.userId } }
        );

        return {
          EM: "Đổi mật khẩu thành công",
          EC: 0,
          DT: updatedUser,
        };
      } else {
        // If the current password doesn't match, return an error
        return {
          EM: "Mật khẩu cũ không chính xác",
          EC: -1,
        };
      }
    } else {
      // If the user doesn't exist, return an error
      return {
        EM: "Người dùng không tồn tại",
        EC: -2,
      };
    }
  } catch (e) {
    console.log("Error:", e);
    return {
      EM: "Lỗi từ máy chủ",
      EC: -3,
    };
  }
};

module.exports = {
  registerNewUser,
  checkUserIdExist,
  checkPhoneExist,
  handleUserLogin,
  hashUserPassword,
  changePassword
};
