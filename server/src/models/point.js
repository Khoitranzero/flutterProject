'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Point extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Point.belongsTo(models.User);
      Point.belongsTo(models.Subject);
    }
  }
  Point.init({
    userId: DataTypes.STRING,
    subjectId:DataTypes.STRING,
    point: DataTypes.INTEGER,
    hocky:DataTypes.STRING,
  }, {
    sequelize,
    modelName: 'Point',
  });
  return Point;
};