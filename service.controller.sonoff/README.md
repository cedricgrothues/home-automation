# service.controller.sonoff

Available on port `4002`
This controller can communicate with all Sonoff devices, including plugs and lamps

## Usage

### Lookup device details

**Definition**

`GET /devices/<id>`

**Response**

- 404: device not found
- 200: success

```json
{
  "identifier": "bedroom-plug",
  "name": "Bedroom Plug",
  "address": "123.456.7.890",
  "state": {
    "power": true
  }
}
```

### Lookup device details

**Definition**

`PUT /devices/<id>`

**Arguments**

- `"power":boolean` the power state of the device

**Response**

- 404: device not found
- 200: success

```json
{
  "identifier": "bedroom-plug",
  "name": "Bedroom Plug",
  "address": "123.456.7.890",
  "state": {
    "power": true
  }
}
```
