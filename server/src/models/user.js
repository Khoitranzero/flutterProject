'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      //relationship
      User.belongsTo(models.Class);
      User.hasMany(models.Point);

    }
  }
  User.init({
    userId:  DataTypes.STRING,
    username: DataTypes.STRING,
    password: DataTypes.STRING,
    address :DataTypes.STRING,
    sex : DataTypes.STRING,
    phone : DataTypes.STRING,
    classId :DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'User',
  });
  return User;
};