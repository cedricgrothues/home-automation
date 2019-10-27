const express = require("express");
const router = express.Router();

const { sequelize, room, device } = require("../database");

router.use(express.urlencoded({ extended: true }));

router
  .route("/")
  .get((req, res) => {
    device
      .findAll({
        include: [room],
        attributes: ["id", "name", "kind", "controller"]
      })
      .then(devices => {
        res.status(200).json(devices);
      })
      .catch(function(err) {
        res.status(500).json({
          message: "A  problem occured while querying all devices: " + err
        });
      });
  })
  .post((req, res) => {
    if (
      !req.body.id ||
      !req.body.name ||
      !req.body.kind ||
      !req.body.room_id ||
      !req.body.controller
    )
      return res.status(400).json({
        message:
          "Missing parameter(s), refer to the documentation for more information."
      });

    if (!/^\w+$/.test(req.body.id))
      return res.status(400).json({
        message:
          "ID contains invalid characters, refer to the documentation for more information."
      });
    device
      .create({
        id: req.body.id,
        name: req.body.name,
        kind: req.body.kind,
        room_id: req.body.room_id,
        controller: req.body.controller
      })
      .then(created => {
        res.status(201).json(created);
      })
      .catch(function(err) {
        res.status(400).json({
          message: "Room with ID '" + req.body.room + "' not found."
        });
      });
  });

router
  .route("/:uid")
  .get((req, res) => {
    device
      .findOne({
        where: {
          id: req.params.uid
        },
        include: [room],
        attributes: ["id", "name", "kind", "controller"]
      })
      .then(device => {
        if (device) res.status(200).json(device);
        else
          res.status(404).json({
            message: "Device with ID '" + req.params.uid + "' not found."
          });
      })
      .catch(function(err) {
        res.status(500).json({
          message:
            "An error occured, while querying for device with id: " +
            req.params.uid +
            " err: " +
            err
        });
      });
  })
  .delete((req, res) => {
    device
      .destroy({
        where: {
          id: req.params.uid
        }
      })
      .then(data => {
        if (data === 0)
          return res.status(404).json({ message: "Device not found." });
        else if (data === 1) return res.sendStatus(204);
        else return res.sendStatus(500);
      });
  });

module.exports = router;
