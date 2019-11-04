# service.controller.plug

Availiable on port `4002`

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
  "type": "plug",
  "controller": "service.controller.plug",
  "state": {
    "power": true
  }
}
```

### Lookup device details

**Definition**

`PATCH /devices/<id>`

**Arguments**

- `"power":boolean` the power state of the device

**Response**

- 404: device not found
- 200: success

```json
{
  "identifier": "bedroom-plug",
  "name": "Bedroom Plug",
  "type": "plug",
  "controller": "service.controller.plug",
  "state": {
    "power": true
  }
}
```
