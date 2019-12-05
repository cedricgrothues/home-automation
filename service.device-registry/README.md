# service.device-registry

Available on port `4001` by default

## Usage

### List all devices

**Definition**

`GET /devices`

**Arguments**

- `"controller":string` filter by the name of the device's controller (optional/query parameter)

**Response**

- 200: success

```json
[
  {
    "id": "bedside-plug",
    "name": "Bedside Plug",
    "type": "plug",
    "controller": "service.controller.plug",
    "room": {
      "id": "bedroom",
      "name": "Cedric's Bedroom"
    }
  },
  {
    "id": "ceiling-lamp",
    "name": "Main Lamp",
    "type": "lamp",
    "controller": "service.controller.hue",
    "room": {
      "id": "bedroom",
      "name": "Cedric's Bedroom"
    }
  }
]
```

### Register a new device

**Definition**

`POST /devices`

**Arguments**

- `"id":string` a globally unique ID for this device, can be used to get the device address
- `"name":string` a friendly name for the device
- `"type":string` the type of device, accepted types: `plug`, `speaker`, `lamp`
- `"room_id":string` the globally unique ID of the room
- `"controller":string` the name of the device's controller

If the ID already exists, an error will be thrown.

**Response**

- 400: unknown room
- 201: created successfully

Returns the new device if successful.

```json
{
  "id": "my-id",
  "name": "My Device",
  "type": "switch",
  "controller": "service.controller.plug",
  "room": {
    "id": "bedroom",
    "name": "Cedric's Bedroom"
  }
}
```

### Lookup device details

**Definition**

`GET /devices/<id>`

**Response**

- 404: device not found
- 200: success

```json
{
  "id": "my-id",
  "name": "My Device",
  "type": "switch",
  "controller": "service.controller.plug",
  "room": {
    "id": "bedroom",
    "name": "Cedric's Bedroom"
  }
}
```

### Delete a device

**Definition**

`DELETE /devices/<id>`

**Response**

- 404: device not found
- 204: success

### List rooms

**Definition**

`GET /rooms`

**Response**

- 200: success

```json
[
  {
    "id": "bedroom",
    "name": "Cedric's Bedroom",
    "devices": [
      {
        "id": "ceiling-lamp",
        "name": "Lamp",
        "type": "lamp",
        "controller": "service.controller.hue"
      }
    ]
  },
  {
    "id": "kitchen",
    "name": "Kitchen",
    "devices": [
      {
        "id": "tv2",
        "name": "TV",
        "type": "tv",
        "controller": "controller-2"
      }
    ]
  }
]
```

### Register new room

**Definition**

`POST /rooms`

**Arguments**

- `"id":string` a globally unique id for the room
- `"name":string` a friendly name for the room

If the id already exists, an error will be thrown.

**Response**

- 201: created successfully

Returns the new room is created successfully.

```json
{
  "id": "bedroom",
  "name": "Cedric's Bedroom"
}
```

### Lookup room details

**Definition**
`GET /rooms/<id>`

**Response**

- 404: room not found
- 200: success

```json
{
  "id": "bedroom",
  "name": "Cedric's Bedroom",
  "devices": [
    {
      "id": "id1",
      "name": "Device 1",
      "type": "switch",
      "controller": "controller-1"
    }
  ]
}
```

### Delete a room

**Definition**

`DELETE /rooms/<id>`

**Response**

- 404: room not found
- 204: success

### List all controllers

**Definition**

`GET /controllers`

**Response**

- 200: success

```json
[
  {
    "id": "service.controller.sonos",
    "address": "127.0.0.1"
  },
  {
    "id": "service.controller.hue",
    "address": "127.0.0.1"
  }
]
```

### Register a new controller

**Definition**

`POST /controllers`

**Arguments**

- `"id":string` a globally unique id for the controller (matches service.controller.\w+)
- `"address":string` the controllers ip address

If the id already exists, the column will be updated.

**Response**

- 201: created successfully

Returns the new room is created successfully.

```json
{
  "id": "service.controller.sonos",
  "address": "127.0.0.1"
}
```

### Delete a controller

**Definition**

`DELETE /controllers/<id>`

**Response**

- 404: room not found
- 204: success