<p align="center">
  <img src=".github/screenshots/icon.png" width="150">
</p>
<h1 align="center">Home Automation</h1>
<h3 align="center">Open-source, distributed home automation system</h3>

<p align="center">
  <a href="https://github.com/cedricgrothues/home-automation/releases">
    <img src="https://img.shields.io/badge/Version-0.1.0+alpha.1-informational">
  </a>
</p>

### About the project

Home Automation is a distributed smart home system largely written in Go, Rust, and Dart. It's mostly meant as a learning opportunity rather than a production-ready system.

The client uses the [Flutter](https://flutter.dev/) framework, which allows building an app for mobile, desktop & web, from a single codebase.

<p align="center">
  <img src=".github/screenshots/setup_light.png" width="256" hspace="4">
  <img src=".github/screenshots/setup_dark.png" width="256" hspace="4">
  <img src=".github/screenshots/home_dark.png" width="256" hspace="4">
</p>

## Download & install

First, clone the repository with the 'clone' command, or download the zip.

```
$ git clone github.com/cedricgrothues/home-automation.git
```

Then, download any IDE, with their respective Rust, Go, Flutter, and Docker plugins.
There you go, you can now open & edit the project.

## Currently supported controllers

| Controller | Description | Status |
| --- | --- | --- |
| modules.aurora | A controller for Nanoleaf Aurora lightpanels      | Preview |
| modules.sonoff | A controller for sonoff tasmota lights and plugs  | Preview |
| modules.sonos  | A controller for all types of sonos speakers      | WIP     |
| modules.hue    | tbd                                               | Planned |

## All services

| Service | Description | Status |
| --- | --- | --- |
| core.api-gateway      | The API Gateway                                   | Preview |
| core.user             | User management                                   | Preview |
| core.device-registry  | The Device Registry Service                       | Preview |
| modules.scene         | The scene controller                              | WIP     |
| modules.schedule      | The schedule controller                           | WIP     |
| modules.aurora        | A controller for Nanoleaf Aurora lightpanels      | Preview |
| modules.sonoff        | A controller for sonoff tasmota lights and plugs  | Preview |
| modules.sonos         | A controller for all types of sonos speakers      | WIP     |

## Usage

All responses will be JSON. Individual service's README's will detail the expected JSON value.
Start all docker containers with: `docker-compose up -d --build --force-recreate`

### API Gateway Service

The API gateway service reads data from `core.api-gateway/config.json` and distributes requests accordingly.
Example config.json structure:

```json
{
    "port": 4000,
    "services": [
        {
            "identifier": "core.device-registry",
            "name": "Device Registry",
            "upstream": "http://core.device-registry:4001"
        },
        {
            "identifier": "modules.sonoff",
            "name": "Sonoff Controller",
            "upstream": "http://modules.sonoff:4002"
        },
        {
            "identifier": "modules.sonos",
            "name": "Sonos Controller",
            "upstream": "http://modules.sonos:4003"
        },
        {
            "identifier": "modules.aurora",
            "name": "Nanoleaf Aurora Controller",
            "upstream": "http://modules.aurora:4004"
        }
    ]
}
```

### Controllers

Controllers must implement a standardized interface for fetching and updating the device state.

`GET modules.<controller-identifier>/device/<device-identifier>`

- 200: success

```json
{
    "id": "lightpanels",
    "name": "Desk Lamp",
    "type": "lamp-color",
    "controller": "modules.aurora",
    "state": {
        "brightness": {
            "value": 50,
            "max": 100,
            "min": 0
        },
        "color_mode": "hs",
        "temperature": {
            "value": 4000,
            "max": 6500,
            "min": 1200
        },
        "hue": {
            "value": 123,
            "max": 360,
            "min": 0
        },
        "power": true,
        "saturation": {
            "value": 100,
            "max": 100,
            "min": 0
        }
    }
}
```

```json
{
  "identifier": "bedroom-plug",
  "name": "Bedroom Plug",
  "type": "plug",
  "controller": "modules.hue",
  "state": {
    "power": true
  }
}
```

`PUT modules.<controller-identifier>/device/<device-identifier>`

JSON request body:

```json
{
    "power": true,
    "brightness": {
        "value": 100,
        "duration": 10
    }
}
```

- 204: success

### Errors

An error will be indicated by a non-2xx status code. The response will include a message.

```json
{
  "message": "Description of what went wrong"
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests and screenshots as appropriate.

## Credits
This project is based on [Jake Wright](https://github.com/jakewright)'s home-automation project and his YouTube series.

## License
[MIT](https://choosealicense.com/licenses/mit/)

---
<sup>1</sup> <a class="anchor" id="1">Core services are required to be written Go or Rust, other services, like controllers, may also be written in Python or NodeJS.</a>
