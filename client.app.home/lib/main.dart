import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import 'package:home/screens/wifi.dart';
import 'package:home/screens/setup/setup.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        StreamProvider(builder: (BuildContext context) => Connectivity().onConnectivityChanged, initialData: ConnectivityResult.wifi),
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
          '/': (context) => Setup(),
          '/setup': (context) => Setup(),
        },
        builder: (context, child) => NetworkAware(child: child),
        locale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
