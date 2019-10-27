const Sequelize = require("sequelize");

const sequelize = new Sequelize(
  "service.device-registry.database",
  "service.device-registry",
  "4prMs6gFWn2tTHFZ",
  {
    dialect: "sqlite",
    logging: false,

    storage: "./storages/registry-database.sqlite",
    define: {
      timestamps: false
    }
  }
);

const room = sequelize.define(
  "rooms",
  {
    id: {
      type: Sequelize.STRING,
      unique: true,
      primaryKey: true
    },
    name: {
      type: Sequelize.STRING,
      unique: false,
      allowNull: false
    }
  },
  {
    underscored: true
  }
);

const device = sequelize.define(
  "devices",
  {
    id: {
      type: Sequelize.STRING,
      unique: true,
      primaryKey: true
    },
    name: {
      type: Sequelize.STRING,
      unique: false,
      allowNull: false
    },
    type: {
      type: Sequelize.STRING,
      unique: false,
      allowNull: false
    },
    controller: {
      type: Sequelize.STRING,
      unique: false,
      allowNull: false
    }
  },
  {
    underscored: true
  }
);

room.hasMany(device, { foreignKey: "room_id" });
device.belongsTo(room, { foreignKey: "room_id" });

module.exports = { device, room, sequelize };
