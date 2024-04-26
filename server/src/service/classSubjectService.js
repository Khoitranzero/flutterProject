import db from "../models";
import { Model, Sequelize, where } from "sequelize";
const getData = async () => {
  try {
    // Danh sách tất cả các môn học
    const allSubjects = await db.Subject.findAll({
      attributes: ["id","subjectId", "subjectName", "credits"], // Lấy cả thông tin credits
    });

    // Mảng để lưu dữ liệu kết quả
    const result = [];

    // Lặp qua từng môn học
    for (const subject of allSubjects) {
      const subjectId = subject.subjectId;
      const subjectName = subject.subjectName;
      const credits = subject.credits; // Thêm thông tin credits

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
      const count = classes.length;
      // Thêm thông tin vào mảng kết quả
      result.push({
        subjectId: subjectId,
        subjectName: subjectName,
        credits: credits,
        classes: classes.map((cls) => ({
          Class: {
            id: cls.Class.id,
            className: cls.Class.className,
            teacherID: cls.Class.teacherID,
          },
        })),
        count: count
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
