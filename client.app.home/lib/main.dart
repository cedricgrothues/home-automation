import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home/screens/wifi.dart';
import 'package:home/screens/setup/setup.dart';
import 'package:home/screens/home/home.dart';
import 'package:home/screens/setup/connect.dart';
import 'package:home/services/scanner.dart';

import 'package:home/components/splash_factory.dart';
import 'package:home/components/not_found.dart';

import 'components/routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        FutureProvider<SharedPreferences>.value(value: SharedPreferences.getInstance()),
        StreamProvider.value(value: Connectivity().onConnectivityChanged, initialData: ConnectivityResult.wifi),
      ],
      child: MaterialApp(
        title: 'Home',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Open Sans',
          buttonColor: Colors.black,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
              size: 26,
            ),
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplashFactory(),
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
            button: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            subtitle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            title: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            body1: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return NoTransitionRoute(
                builder: (_) => Splash(),
                settings: settings,
              );
            case '/home':
              return NoTransitionRoute(
                builder: (_) => Home(),
                settings: settings,
              );
            case '/setup':
              return NoPopTransitionRoute(
                builder: (_) => Setup(),
                settings: settings,
              );
            case '/not_found':
              return NoTransitionRoute(
                builder: (_) => NotFound(),
                settings: settings,
              );
            case '/wifi_required':
              return NoTransitionRoute(
                builder: (_) => NoWifi(),
                settings: settings,
              );
            case '/connect':
              return NoTransitionRoute(
                builder: (_) => FutureProvider<String>.value(
                  value: discover(),
                  child: Connect(),
                ),
              );
            default:
              return null;
          }
        },
        locale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = Provider.of<SharedPreferences>(context);

    if (prefs != null) {
      if (!prefs.containsKey("service.device-registry")) {
        try {
          http.Response response = await http.get("http://${prefs.getString("service.device-registry")}:4000/");

          if (response.statusCode != 200) return;

          Map map = json.decode(response.body);

          if (!map.containsKey("name") || map["name"] != "service.device-registry") return;

          Navigator.of(context).pushReplacementNamed("/home");
        } catch (error) {
          Navigator.of(context).pushReplacementNamed("/setup");
          print(error);
        }
      } else
        Navigator.of(context).pushReplacementNamed("/setup");
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
