import 'dart:convert';
import 'dart:io';

void Function(HttpRequest) get = (request) {
  List<Map> data = [
    {
      "id": "id1",
      "address": "125.243.21",
      "name": "Device 1",
      "type": "hs100",
      "kind": "switch",
      "controller_name": "controller-1",
      "room": {"id": "bedroom", "name": "Cedric's Bedroom"}
    },
    {
      "id": "id2",
      "address": "125.243.212",
      "name": "Device 2",
      "type": "huelight",
      "kind": "lamp",
      "controller_name": "controller-2",
      "room": {"id": "kitchen", "name": "Kitchen"}
    }
  ];

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(json.encode(data))
    ..close();
};

void Function(HttpRequest) post = (request) {
  Map data = {
    "id": "id1",
    "name": "Device 1",
    "type": "hs100",
    "kind": "switch",
    "controller_name": "controller-2",
    "room": {"id": "bedroom", "name": "Jake's Bedroom"}
  };

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(json.encode(data))
    ..close();
};

void Function(HttpRequest) lookup = (request) {
  Map data = {
    "id": "id1",
    "name": "Device 1",
    "type": "hs100",
    "kind": "switch",
    "controller_name": "controller-2",
    "room": {"id": "bedroom", "name": "Jake's Bedroom"}
  };

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(json.encode(data))
    ..close();
};

void Function(HttpRequest) delete = (request) {
  request.response
    ..statusCode = HttpStatus.noContent
    ..close();
};
