const express = require("express");
const router = express.Router();

const { sequelize, room, device } = require("../database");

router.use(express.urlencoded({ extended: true }));

router.get("/", (req, res, next) => {
  if (req.query.controller != null) {
    device
      .findAll({
        where: {
          controller: req.query.controller
        },
        include: [room],
        attributes: ["id", "name", "type", "controller", "address"]
      })
      .then(devices => {
        res.status(200).json(devices);
      })
      .catch(function(err) {
        err.status = 500;
        return next(err);
      });
  } else {
    device
      .findAll({
        include: [room],
        attributes: ["id", "name", "type", "controller", "address"]
      })
      .then(devices => {
        res.status(200).json(devices);
      })
      .catch(function(err) {
        const error = new Error(
          "A  problem occured while querying all devices: " + err
        );
        error.status = 500;
        return next(error);
      });
  }
});

router.post("/", (req, res, next) => {
  if (
    !req.body.id ||
    !req.body.name ||
    !req.body.type ||
    !req.body.room_id ||
    !req.body.controller ||
    !req.body.address
  ) {
    const error = new Error(
      "Missing parameter(s), refer to the documentation for more information."
    );
    error.status = 400;
    return next(error);
  }

  if (!/^\w+$/.test(req.body.id)) {
    const error = new Error(
      "ID contains invalid characters, refer to the documentation for more information."
    );
    error.status = 400;
    return next(error);
  }
  device
    .create({
      id: req.body.id,
      name: req.body.name,
      type: req.body.type,
      room_id: req.body.room_id,
      controller: req.body.controller,
      address: req.body.address
    })
    .then(created => {
      res.status(201).json(created);
    })
    .catch(function(err) {
      const error = new Error(
        "Could not create room with ID: " + req.body.id + ". " + err
      );
      error.status = 500;
      return next(error);
    });
});

router.get("/:uid", (req, res, next) => {
  (req.query.controller
    ? device.findOne({
        where: {
          id: req.params.uid,
          controller: req.query.controller
        },
        include: [room],
        attributes: ["id", "name", "type", "controller", "address"]
      })
    : device.findOne({
        where: {
          id: req.params.uid
        },
        include: [room],
        attributes: ["id", "name", "type", "controller", "address"]
      })
  )
    .then(device => {
      if (device) res.status(200).json(device);
      else {
        res.status(404).json({
          message: "Device with ID '" + req.params.uid + "' not found."
        });
      }
    })
    .catch(function(err) {
      const error = new Error(
        "An error occured, while querying for device with id: " +
          req.params.uid +
          ". " +
          err
      );
      error.status = 500;
      return next(error);
    });
});

router.delete("/:uid", (req, res, next) => {
  device
    .destroy({
      where: {
        id: req.params.uid
      }
    })
    .then(data => {
      if (data === 0) {
        const error = new Error("Device not found.");
        error.status = 404;
        return next(error);
      } else if (data === 1) {
        return res.sendStatus(204);
      } else {
        const error = new Error("Internal server error.");
        error.status = 500;
        return next(error);
      }
    });
});

module.exports = router;
