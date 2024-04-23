import db from "../models";
import { Model, Sequelize, where } from "sequelize";
const getData = async () => {
  try {
    // Lấy danh sách tất cả các bản ghi từ bảng Room
    const rooms = await db.Room.findAll();

    // Mảng để lưu dữ liệu kết quả
    const result = [];

    // Lặp qua từng bản ghi trong bảng Room
    for (const room of rooms) {
      const userId = room.userId;
      const classId = room.classId;

      // Tìm thông tin của sinh viên từ userId
      const student = await db.User.findOne({
        where: { userId: userId },
        attributes: ["userId", "username", "address", "phone", "sex"],
      });

      // Kiểm tra nếu không tìm thấy sinh viên, bỏ qua
      if (!student) {
        continue;
      }

      // Tìm thông tin của lớp học từ classId
      const classInfo = await db.Class.findOne({
        where: { id: classId },
        attributes: ["id", "className", "teacherID"],
      });

      // Nếu không tìm thấy thông tin lớp học, bỏ qua
      if (!classInfo) {
        continue;
      }

      // Kiểm tra xem sinh viên đã tồn tại trong kết quả hay chưa
      const existingStudent = result.find((item) => item.student.userId === userId);

      if (existingStudent) {
        // Nếu sinh viên đã tồn tại, thêm thông tin lớp học vào danh sách của sinh viên
        existingStudent.classes.push(classInfo);
      } else {
        // Nếu sinh viên chưa tồn tại, tạo một đối tượng mới và thêm vào kết quả
        result.push({
          student: student,
          classes: [classInfo],
        });
      }
    }

    return {
      EM: "Get data success",
      EC: 0,
      DT: result,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Error fetching data",
      EC: 1,
      DT: [],
    };
  }
};



module.exports = {
  getData,
};
