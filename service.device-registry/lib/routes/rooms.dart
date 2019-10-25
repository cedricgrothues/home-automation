import 'dart:convert';
import 'dart:io';

void Function(HttpRequest) get = (request) {
  List<Map> data = [
    {
      "id": "bedroom",
      "name": "Cedric's Bedroom",
      "devices": [
        {"id": "lamp1", "name": "Lamp", "type": "huelight", "kind": "lamp", "controller_name": "controller-1"}
      ]
    },
    {
      "id": "kitchen",
      "name": "Kitchen",
      "devices": [
        {"id": "tv2", "name": "TV", "type": "philips48", "kind": "tv", "controller_name": "controller-2"}
      ]
    }
  ];

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(json.encode(data))
    ..close();
};

void Function(HttpRequest) post = (request) {
  Map data = {"id": "bedroom", "name": "Cedric's Bedroom", "devices": []};

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(json.encode(data))
    ..close();
};

void Function(HttpRequest) lookup = (request) {
  Map data = {
    "id": "bedroom",
    "name": "Cedric's Bedroom",
    "devices": [
      {"id": "id1", "name": "Device 1", "type": "hs100", "kind": "switch", "controller_name": "controller-1"}
    ]
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
