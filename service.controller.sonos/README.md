# service.controller.sonos

Availiable on port `4003`

## Usage

### Lookup device details

**Definition**

`GET /devices/<id>`

**Response**

- 404: device not found
- 200: success

```json (This is most likely going to be updated within the next couple of days)
{
  "identifier": "kitchen-sonos",
  "name": "Sonos on the kitchen counter",
  "address": "123.456.7.890",
  "state": {
    "status": {
      "status": "playing",
      "service": "Apple Music",
      "song": "song-uid"
    },
    "volume": {
      "type": "int",
      "min": 0,
      "max": 10,
      "value": 3
    }
  }
}
```

### Lookup device details

**Definition**

`PATCH /devices/<id>`

**Arguments**

- `"volume":int` adjust the device volume

**Response**

- 404: device not found
- 200: success

```json (This is most likely going to be updated within the next couple of days)
{
  "identifier": "kitchen-sonos",
  "name": "Sonos on the kitchen counter",
  "address": "123.456.7.890",
  "state": {
    "status": {
      "status": "paused",
      "service": "Apple Music",
      "song": "song-uid"
    },
    "volume": {
      "type": "int",
      "min": 0,
      "max": 10,
      "value": 3
    }
  }
}
```
