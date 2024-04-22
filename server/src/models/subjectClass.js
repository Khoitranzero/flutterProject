"use strict";
const { Model } = require("sequelize");
const Subject = require("./subject"); // Import model Subject
const Class = require("./class");
module.exports = (sequelize, DataTypes) => {
  class SubjectClass extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Subject.belongsToMany(models.Class, { through: SubjectClass });
      Class.belongsToMany(models.Subject, { through: SubjectClass });
    }
  }
  SubjectClass.init(
    {
      subjectId: DataTypes.STRING,
      classId: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: "SubjectClass",
    }
  );
  return SubjectClass;
};
