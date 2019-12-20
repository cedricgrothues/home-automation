import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import 'package:home/screens/add.dart';
import 'package:home/screens/wifi.dart';
import 'package:home/screens/splash.dart';
import 'package:home/screens/home/home.dart';
import 'package:home/screens/setup/setup.dart';
import 'package:home/screens/errors/failed.dart';
import 'package:home/screens/setup/connect.dart';
import 'package:home/screens/setup/account.dart';
import 'package:home/screens/controls/lights.dart';

import 'package:home/services/scanner.dart';
import 'package:home/components/routes.dart';
import 'package:home/components/splash_factory.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        StreamProvider<ConnectivityResult>.value(
            value: Connectivity().onConnectivityChanged, initialData: ConnectivityResult.wifi),
      ],
      child: MaterialApp(
        title: 'Home',
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Color(0xFFFEFFFF),
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
          cupertinoOverrideTheme: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black,
            barBackgroundColor: Colors.transparent,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 26,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplashFactory(),
          cardColor: Color(0xfff2f2f7),
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
            body2: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.black,
            ),
            caption: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.7),
            ),
            subhead: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Open Sans',
          buttonColor: Colors.white,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 26,
            ),
          ),
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Colors.white,
            brightness: Brightness.light,
            barBackgroundColor: Colors.transparent,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 26,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplashFactory(),
          cardColor: Color(0xFF1C1C1E),
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
            button: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            subtitle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            title: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            body1: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
            body2: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.white,
            ),
            caption: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
            subhead: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),

        // The initial route is required to be the spash screen if
        // Hive is used, since it's initialized in Spash's initState
        initialRoute: '/',
        builder: (context, Widget child) => NetworkAware(child: child),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return FadeTransitionRoute(
                page: Splash(),
              );
            case '/home':
              return NoTransitionRoute(
                builder: (_) => Home(),
                settings: settings,
              );
            case '/setup':
              return NoTransitionRoute(
                builder: (_) => Setup(),
                settings: settings,
              );
            case '/account_setup':
              return FadeTransitionRoute(
                page: AccountSetup(),
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
            case '/connection_failed':
              return NoTransitionRoute(
                builder: (_) => ConnectionFailed(),
              );
            case '/dimmable_light':
              return MaterialPageRoute(
                builder: (_) => LightController(dimmable: true, id: "bedroom-lamp"),
              );
            case '/add':
              return SlideTransitionRoute(
                page: Add(),
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
