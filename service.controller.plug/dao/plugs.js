const axios = require("axios");

const CONTROLLER_NAME = "service.controller.plug";

const fetchAll = async () => {
  axios
    .get(
      encodeURI("http://localhost:4000/devices?controller=" + CONTROLLER_NAME)
    )
    .then(response => {
      get_state(response);
    })
    .catch(error => {
      console.error(error);
    });
};

const fetchOne = async id => {
  axios
    .get(
      encodeURI(
        `http://localhost:4000/devices/${id}?controller=${CONTROLLER_NAME}`
      )
    )
    .then(response => {
      console.log(response);
    })
    .catch(error => {
      throw error;
    });
};

const get_state = async response => {
  response.data.forEach(plug => {
    set_state(plug, false);
  });
};

const toogle = async plug => {
  axios
    .get(encodeURI(`http://${plug.address}/cm?cmnd=Power0 2`))
    .then(response => {
      console.log(response.data);
    })
    .catch(error => {
      console.error(error);
    });
};

const set_state = async (plug, state) => {
  axios
    .get(
      encodeURI(`http://${plug.address}/cm?cmnd=Power0 ${state ? "1" : "0"}`)
    )
    .then(response => {
      console.log(response.data);
    })
    .catch(error => {
      console.error(error);
    });
};

module.exports = { fetchAll, fetchOne };
