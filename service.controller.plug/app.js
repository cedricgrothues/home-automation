const express = require("express");

const devices = require("./routes/devices");
const logger = require("./logger");

const app = express();

const PORT = process.env.PORT || 4001;

app.use(express.json());

app.use("/devices", devices);

app.use((err, req, res, next) => {
  if (!err.status) err.status = 500;

  logger.error(
    "service.controller.plug",
    `${req.method} ${req.url} ${err.status}: ${err.message}`
  );
  res.status(err.status).json({
    message: err.message
  });
});

app.listen(PORT, () =>
  logger.info(
    "service.controller.plug",
    "Server is up and running on port: " + PORT
  )
);
