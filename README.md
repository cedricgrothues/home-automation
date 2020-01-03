# Home Automation

Home Automation is a distributed smart home system largely written in Go.
It's mostly meant as a learning opportunity rather than a production-ready system.

<kbd><img src=".github/screenshots/setup_light.png" width=200/></kbd>
<kbd><img src=".github/screenshots/setup_dark.png" width=200/></kbd>

## Currently supported services

| Service | Status |
| --- | --- |
| service.controller.aurora | Alpha |
| service.controller.sonoff | Alpha |
| service.controller.sonos  | WIP   |
| service.controller.hue    | Planned |

## Usage

All responses will be JSON. Individual service's README's will detail the expected JSON value.
Start all docker containers with: `docker-compose up -d --build --force-recreate`

### API Gateway Service

The api gateway service reads data from `service.api-gateway/config.yaml` and distributes requests accordingly.
Example config.yaml structure:
```yaml
port: 4000

services:
    service.device-registry:
        name: Device Registry
        prefix: service.device-registry
        upstream: "http://192.168.2.117:4001"
    service.controller.sonoff:
        name: Sonoff Controller
        prefix: service.controller.sonoff
        upstream: "http://192.168.2.117:4002"
    service.controller.sonos:
        name: Sonos Controller
        prefix: service.controller.sonos
        upstream: "http://192.168.2.117:4003"
```

### Controllers

Controllers must implement a standardised interface for fetching and updating device state.

`GET service.controller.<controller-identifier>/device/<device-identifier>`

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
This project is based on [Jake Wright](https://github.com/jakewright)'s idea of a home-automation system, his youtube series and his home-automation repo.

## License
[MIT](https://choosealicense.com/licenses/mit/)
