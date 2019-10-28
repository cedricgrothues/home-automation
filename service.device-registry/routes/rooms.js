const express = require("express");
const router = express.Router();

const { sequelize, room, device } = require("../database");

router.use(express.urlencoded({ extended: true }));

router.get("/", (req, res, next) => {
  room
    .findAll({
      include: [
        {
          model: device,
          attributes: ["id", "name", "type", "controller", "address"]
        }
      ]
    })
    .then(rooms => {
      res.status(200).json(rooms);
    })
    .catch(function(err) {
      const error = new Error(
        "A  problem occured while querying all rooms: " + err
      );
      error.status = 500;
      return next(error);
    });
});

router.post("/", (req, res, next) => {
  if (!req.body.id || !req.body.name) {
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
  room
    .create({ id: req.body.id, name: req.body.name })
    .then(created => {
      res.status(201).json(created);
    })
    .catch(function(err) {
      const error = new Error(
        "A  problem occured while inserting object into database: " + err
      );
      error.status = 500;
      return next(error);
    });
});

router.get("/:uid", (req, res, next) => {
  room
    .findOne({
      where: {
        id: req.params.uid
      },
      include: [
        {
          model: device,
          attributes: ["id", "name", "type", "controller", "address"]
        }
      ]
    })
    .then(room => {
      if (!room) {
        const error = new Error(
          "Room with ID '" + req.params.uid + "' not found."
        );
        error.status = 404;
        return next(error);
      } else {
        res.status(200).json(room);
      }
    })
    .catch(function(err) {
      const error = new Error(
        "An error occured, while querying for room with id: " +
          req.params.uid +
          " err: " +
          err
      );
      error.status = 500;
      return next(error);
    });
});

router.delete("/:uid", (req, res, next) => {
  room
    .destroy({
      where: {
        id: req.params.uid
      }
    })
    .then(data => {
      if (data === 0) {
        const error = new Error("Room not found.");
        error.status = 404;
        return next(error);
      } else if (data === 1) return res.sendStatus(204);
      else {
        const error = new Error("Internal server error");
        error.status = 500;
        return next(error);
      }
    });
});

module.exports = router;
