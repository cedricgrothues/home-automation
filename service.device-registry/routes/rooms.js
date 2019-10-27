const express = require("express");
const router = express.Router();

const { sequelize, room, device } = require("../database");

router.use(express.urlencoded({ extended: true }));

router
  .route("/")
  .get((req, res) => {
    room
      .findAll({
        include: [
          { model: device, attributes: ["id", "name", "type", "controller"] }
        ]
      })
      .then(rooms => {
        res.status(200).json(rooms);
      })
      .catch(function(err) {
        res.status(500).json({
          message: "A  problem occured while querying all rooms: " + err
        });
      });
  })
  .post((req, res) => {
    if (!req.body.id || !req.body.name)
      return res.status(400).json({
        message:
          "Missing parameter(s), refer to the documentation for more information."
      });

    if (!/^\w+$/.test(req.body.id))
      return res.status(400).json({
        message:
          "ID contains invalid characters, refer to the documentation for more information."
      });
    room
      .create({ id: req.body.id, name: req.body.name })
      .then(created => {
        res.status(201).json(created);
      })
      .catch(function(err) {
        res.status(500).json({
          message:
            "A  problem occured while inserting object into database: " + err
        });
      });
  });

router
  .route("/:uid")
  .get((req, res) => {
    room
      .findOne({
        where: {
          id: req.params.uid
        },
        include: [
          { model: device, attributes: ["id", "name", "type", "controller"] }
        ]
      })
      .then(room => {
        if (room) res.status(200).json(room);
        else
          res.status(404).json({
            message: "Room with ID '" + req.params.uid + "' not found."
          });
      })
      .catch(function(err) {
        res.status(500).json({
          message:
            "An error occured, while querying for room with id: " +
            req.params.uid +
            " err: " +
            err
        });
      });
  })
  .delete((req, res) => {
    room
      .destroy({
        where: {
          id: req.params.uid
        }
      })
      .then(data => {
        if (data === 0)
          return res.status(404).json({ message: "Room not found." });
        else if (data === 1) return res.sendStatus(204);
        else return res.sendStatus(500);
      });
  });

module.exports = router;
