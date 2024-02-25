const Sequelize = require("sequelize");

module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "cauhinh",
    {
      ID: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      kichThuocManHinh: {
        type: DataTypes.FLOAT,
        allowNull: false,
        field: "kich thuoc man hinh",
      },
      cpu: {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      cardDoHoa: {
        type: DataTypes.STRING(255),
        allowNull: false,
        field: "card do hoa",
      },
      ram: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      tanSoManHinh: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "tan so man hinh",
      },
      gia: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      tableName: "Cau Hinh",
      timestamps: false,
    }
  );
};
