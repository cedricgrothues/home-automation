# Home Automation

Distributed home automation system largely written in Go. Mostly a learning opportunity rather than a production-ready system. Inspired by [Jake Wright](https://github.com/jakewright)'s home-automation youtube series.

`4000`: service.device-registry

## API Specification

All responses will be JSON.

Individual service's READMEs will detail the expected JSON value.

## Errors

An error will be indicated by a non-2xx status code. The response will include a message.

```json
{
  "message": "Description of what went wrong"
}
```

### Controllers

Controllers must implement a standardised interface for fetching and updating device state.

`GET service.controller.x/device/<device-identifier>`

- 200: success

```json
{
  "identifier": "table-lamp",
  "name": "Table Lamp",
  "type": "lamp",
  "controller": "service.controller.hue",
  "state": {
    "brightness": {
      "type": "int",
      "min": 0,
      "max": 254,
      "interpolation": "continuous",
      "value": 100
    }
  }
}
```

```json
{
  "identifier": "bedroom-plug",
  "name": "Bedroom Plug",
  "type": "plug",
  "controller": "service.controller.hue",
  "state": {
    "power": true
  }
}
```
