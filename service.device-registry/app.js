const express = require("express");
const Sequelize = require("sequelize");

const devices = require("./routes/devices");
const rooms = require("./routes/rooms");

const { sequelize } = require("./database");

sequelize.sync();

const app = express();

const PORT = process.env.PORT || 4000;

app.use(express.json());

app.use("/devices", devices);
app.use("/rooms", rooms);

app.listen(PORT);
