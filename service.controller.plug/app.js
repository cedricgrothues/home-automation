const express = require("express");

const app = express();

const PORT = process.env.PORT || 4001;

app.use(express.json());

// app.use("/devices", devices);

app.listen(PORT, () =>
  console.log("service.controller.plug is listening on port: " + PORT)
);
