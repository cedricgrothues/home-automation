# service.device-registry

Availiable on port `4000`

## Usage

### List all devices

**Definition**

`GET /devices`

**Response**

- 200: success

```json
[
  {
    "id": "bedside-plug",
    "name": "Bedside Plug",
    "kind": "plug",
    "controller": "service.controller.plug",
    "room": {
      "id": "bedroom",
      "name": "Cedric's Bedroom"
    }
  },
  {
    "id": "ceiling-lamp",
    "name": "Main Lamp",
    "kind": "lamp",
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
- `"kind":string` the kind of device e.g. lamp
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
  "kind": "switch",
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
  "kind": "switch",
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
        "kind": "lamp",
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
        "kind": "tv",
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
      "kind": "switch",
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
