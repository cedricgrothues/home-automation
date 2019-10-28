const express = require("express");
const router = express.Router();

const plugs = require("../dao/plugs");

router.use(express.urlencoded({ extended: true }));

router
  .route("/:uid")
  .get((req, res) => {
    plugs.fetchOne("bedside_plug").then(data => res.json(data));
  })
  .patch((req, res) => {
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
