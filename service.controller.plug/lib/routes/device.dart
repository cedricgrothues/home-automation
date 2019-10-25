import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:service.controller.plug/data/static.dart' as data;

Future get(HttpRequest request) async {
  String id = request.uri.pathSegments[1];

  Map device = data.response.where((device) => device['identifier'] == id).first;

  http.Response response = await http.get('${device['address']}/cm?cmnd=Power');

  Map map = {
    'identifier': device['identifier'],
    'name': device['name'],
    'type': device['type'],
    'controller': device['controller'],
    'state': {
      'power': json.decode(response.body)['POWER'] == "ON",
    }
  };

  await request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(json.encode(map))
    ..close();
}

void update(HttpRequest request) {}
