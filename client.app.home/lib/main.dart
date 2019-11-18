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

import 'package:home/components/splash_factory.dart';
import 'package:home/components/transitions.dart';

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
        routes: {
          '/': (context) => Splash(),
          '/setup': (context) => Setup(),
          '/rooms': (context) => Home(),
        },
        builder: (context, child) => NetworkAware(child: child),
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
      if (prefs.containsKey("service.device-registry")) {
        http.Response response = await http.get("http://${prefs.getString("service.device-registry")}:4000/");

        if (response.statusCode != 200) return;

        Map map = json.decode(response.body);

        if (!map.containsKey("name") || map["name"] != "service.device-registry") return;

        Navigator.of(context).pushReplacement(FadeRoute(page: Home()));
      } else
        Navigator.of(context).pushReplacement(FadeRoute(page: Setup()));
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
