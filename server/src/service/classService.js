import db from "../models";
const checkClassNameExist = async (className) => {
  let classname = await db.Class.findOne({
    where: { 
      className: className },
  });

  if (classname) {
    return true;
  }
  return false;
};
const checkUserInClassExist = async (classId) => {
  let userInClass = await db.User.findOne({
    where: { 
      classId: classId },
  });

  if (userInClass) {
    return true;
  }
  return false;
};
const getClass = async () => {
  try {
    const classes = await db.Class.findAll();
    return {
      EM: "Get classes success",
      EC: 0,
      DT: classes,
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
    console.log("classanme", data)
    let isClassNameExist = await checkClassNameExist(data.className);
    console.log("first",isClassNameExist)
    if(isClassNameExist===true) {
        return{
            EM : 'Lớp học này đã tồn tại',
            EC : 2,
            DT :[]
        }
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
      await db.User.update(
        { classId: null },
        { where: { classId: data.id } }
      );
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
      attributes: {exclude: ['createdAt', 'updatedAt']},
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
    return {
      EM: "Get classes success",
      EC: 0,
      DT: classes,
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
};
