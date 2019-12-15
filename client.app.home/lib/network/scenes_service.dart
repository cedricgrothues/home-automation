// TODO: IMPLEMENT SCENES SERVICE AFTER CREATING THE ACCORDING MICROSERVICE

import 'package:home/network/models/scene.dart';

class SceneService {
  static Future<List<Scene>> fetch() async {
    return [
      Scene(name: "I'm home"),
      Scene(name: "Movie Night"),
      Scene(name: "Netflix & Chill"),
      Scene(name: "Movie Night"),
      Scene(name: "Movie Night"),
    ];
  }

  static void trigger(Scene scene) async {}
}
