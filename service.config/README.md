# service.config

Available on port `4001`
This service provides information to device-registry and controllers

## Usage

### Lookup a service config

**Definition**

`GET /read/<id>`

**Response**

- 404: service not found
- 200: success

```json
{
  "identifier": "service.device-registry",
  "friendly": "Device Registry",
  "port": 4000,
  "options": {}
}
```

### Get all controllers

**Definition**

`GET /controllers`

**Response**

- 200: success
- 500: internal server error

```json
[
  {
    "identifier": "service.controller.sonoff",
    "friendly": "Sonoff Controller",
    "port": 4002
  },
  {
    "identifier": "service.controller.sonos",
    "friendly": "Sonos Controller",
    "port": 4003
  }
]
```

### Reload the config

**Definition**

`GET /reload`

**Response**

- 500: internal server error
- 200: success

```json
{
  "message": "Config file reloaded successfully"
}
```
