const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "khuvuc",
    {
      "loai khu vuc": {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      "phu thu": {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      tableName: "Khu Vuc",
      hasTrigger: true,
      timestamps: false,
    }
  );
};
