# service.controller.aurora

Available on port `4004`
This controller can communicate with Nanoleaf Aurora devices

## Usage

### Lookup device details

**Definition**

`GET /devices/<id>`

**Response**

- 404: device not found
- 200: success

```json
{
    "id": "lightpanels",
    "name": "Desk Lamp",
    "type": "lamp-color",
    "controller": "service.controller.aurora",
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

### Lookup device details

**Definition**

`PATCH /devices/<id>`

**Arguments**

- `"power":boolean`     the power state of the device
- `"brightness":int`    the brightness of the device
- `"saturation":int`    the saturation of the device
- `"temperature":int`   the color temperature of the device
- `"hue":int`           the hue of the device

**Response**

- 404: device not found
- 204: success
