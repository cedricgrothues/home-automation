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
