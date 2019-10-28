const express = require("express");
const Sequelize = require("sequelize");

const devices = require("./routes/devices");
const rooms = require("./routes/rooms");
const logger = require("./logger");

const { sequelize } = require("./database");

sequelize.sync();

const app = express();

const PORT = process.env.PORT || 4000;

app.use(express.json());

app.use("/devices", devices);
app.use("/rooms", rooms);

app.use((err, req, res, next) => {
  if (!err.status) err.status = 500;

  logger.error(
    "service.device-registry",
    `${req.method} ${req.url} ${err.status}: ${err.message}`
  );
  res.status(err.status).json({
    message: err.message
  });
});

app.listen(PORT, () =>
  logger.info(
    "service.device-registry",
    "Server is up and running on port: " + PORT
  )
);
