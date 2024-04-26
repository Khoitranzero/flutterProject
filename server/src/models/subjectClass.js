"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class SubjectClass extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
        SubjectClass.belongsTo(models.Subject, {foreignKey: 'subjectId'})
        SubjectClass.belongsTo(models.Class, {foreignKey: 'classId'})
    }
    
  }
  SubjectClass.init(
    {
      subjectId: DataTypes.STRING,
      classId: DataTypes.STRING,
      teacherId: DataTypes.STRING
    },
    {
      sequelize,
      modelName: "SubjectClass",
    }
  );
  return SubjectClass;
};
