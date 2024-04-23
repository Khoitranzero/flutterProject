import db from "../models";
import { Model, Sequelize, where } from "sequelize";
const getData = async () => {
  try {
    // Danh sách tất cả các môn học
    const allSubjects = await db.Subject.findAll({
      attributes: ["subjectId"],
    });

    // Mảng để lưu dữ liệu kết quả
    const result = [];

    // Lặp qua từng môn học
    for (const subject of allSubjects) {
      const subjectId = subject.subjectId;

      // Tìm tất cả các lớp học của môn học hiện tại
      const classes = await db.SubjectClass.findAll({
        where: { subjectId: subjectId },
        include: [
          {
            model: db.Class,
            attributes: ["id", "className", "teacherID"],
          },
        ],
      });
      if (classes.length === 0) {
        continue;
      }
      // Thêm thông tin vào mảng kết quả
      result.push({
        subjectId: subjectId,
        classes: classes,
      });
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
