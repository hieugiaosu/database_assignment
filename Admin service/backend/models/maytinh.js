const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "maytinh",
    {
      ID: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        defaultValue: 1,
      },
      hang: {
        type: DataTypes.STRING(255),
        allowNull: true,
      },
      "ngay mua": {
        type: DataTypes.DATE,
        allowNull: true,
      },
      "phan loai khu vuc": {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      "id cau hinh": {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      tableName: "May Tinh",
      hasTrigger: true,
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [{ name: "ID" }],
        },
      ],
    }
  );
};
