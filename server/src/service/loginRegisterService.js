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
    let prefix;
    if(rawUserData.role === "Giảng viên") {
      prefix = "gv";
    } else if (rawUserData.role === "Sinh viên") {
      prefix = "dh";
    }
    const randomNumber = Math.floor(10000000 + Math.random() * 90000000);
    const generatedUserId = `${prefix}${randomNumber}`;

    let isUserIdExist = await checkUserIdExist(generatedUserId);
    if (isUserIdExist === true) {
      return {
        EM: "MSSV này đã được sử dụng, vui lòng nhập đúng MSSV đã được cấp",
        EC: 1,
      };
    }
    let isPhoneExist = await checkPhoneExist(rawUserData.phone);
    if (isPhoneExist === true) {
      return {
        EM: "Số điện thoại đã được sử dụng, vui lòng nhập số điện thoại khác",
        EC: 1,
      };
    }

    let hashPassword = hashUserPassword(rawUserData.password);

    await db.User.create({
      userId: generatedUserId,
      username: rawUserData.username,
      password: hashPassword,
      phone: rawUserData.phone,
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
    // console.log("rawData",rawData)
    let user = await db.User.findOne({
      where: {
        [Op.or]: [
           { userId: rawData.valueLogin },
          { phone: rawData.valueLogin },
        ],
      },
    });
    // console.log("user",user)
    if (user) {
      let isCorrectPassword = chekPassword(rawData.password, user.password);
      if (isCorrectPassword === true) {
        //let getclass = await getClassName(user);
        let payload = {
          userId: user.userId,
          //getclass,
          username: user.username,
        };
        let token = createJWT(payload);
        return {
          EM: "Đăng nhập thành công",
          EC: 0,
          DT: {
            access_token: token,
            //getclass,
            userId: user.userId,
            username: user.username,
          },
        };
      }
    }
    console.log(
      "not found student with masv/phone  ",
      rawData.valueLogin,
      "pasword",
      rawData.password
    );
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
module.exports = {
  registerNewUser,
  checkUserIdExist,
  checkPhoneExist,
  handleUserLogin,
  hashUserPassword,
};
