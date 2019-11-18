# Home Automation

Home Automation is a distributed smart home system largely written in Go. 
It's mostly meant as a learning opportunity rather than a production-ready system.

## Usage

All responses will be JSON. Individual service's READMEs will detail the expected JSON value.

<!-- NOT YET IMPLEMENTED
### Config Service
The config service reads and distributes configuration information from service.config/data/config.yaml.
Default config.yaml structure:
```yaml
development: Yes # Production or development environment?

services:
  service.example:
    package: service.example
    name: Example Service
    port: 80
``` 
-->

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

Please make sure to update tests as appropriate.

## Credits
This project is based on [Jake Wright](https://github.com/jakewright)'s idea of a home-automation system, his youtube series and his home-automation repo.

## License
[MIT](https://choosealicense.com/licenses/mit/)
