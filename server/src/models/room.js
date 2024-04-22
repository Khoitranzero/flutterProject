"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Room extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // Quan hệ với bảng User
      Room.belongsTo(models.User, { foreignKey: "userId" });
      // Quan hệ với bảng Class
      Room.belongsTo(models.Class, { foreignKey: "classId" });
    }
  }
  Room.init(
    {
      userId: DataTypes.STRING,
      classId: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: "Room",
    }
  );
  return Room;
};
