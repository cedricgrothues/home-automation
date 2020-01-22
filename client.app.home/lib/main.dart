import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';

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

import 'package:home/components/routes.dart';
import 'package:home/components/splash.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This locks the device orientation to a portrait up position.
    // After sufficient testing, edit this list to enable other device orientations.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight]);

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        // Register a stream provider that listens to the connectivity result
        // This is used in screens/wifi to show a 'not connected' page, if wifi is
        // not availiable. Register all other global providers here.
        StreamProvider<ConnectivityResult>.value(
          value: Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.wifi,
        ),
      ],
      child: MaterialApp(
        title: 'Home',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Color(0xFFFEFEFE),
          fontFamily: 'Open Sans',
          buttonColor: Colors.black,
          canvasColor: Colors.black12,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
              size: 26,
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Color(0xFFFEFEFE),
            elevation: 0,
            actionTextColor: Colors.black,
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
          toggleButtonsTheme: ToggleButtonsThemeData(
            fillColor: Color(0xFFEEEEEF),
            color: Color(0xFF828287),
          ),
          splashFactory: NoSplashFactory(),
          cardColor: Color(0xFFFEFEFE),
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 24,
              color: Color(0xFF121112),
              fontWeight: FontWeight.w600,
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.black,
            ),
            caption: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9A9A9E),
            ),
            subhead: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.white10,
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
            brightness: Brightness.dark,
            barBackgroundColor: Colors.transparent,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.black,
            elevation: 0,
            actionTextColor: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 26,
          ),
          toggleButtonsTheme: ToggleButtonsThemeData(
            fillColor: Color(0xFF313135),
            color: Color(0xFFA1A1A8),
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplashFactory(),
          cardColor: Color(0xFF1C1C1E),
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 23,
              color: Colors.white,
              fontWeight: FontWeight.w700,
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.white,
            ),
            caption: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8C8C91),
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

        // As mentioned above, every child is wrapped in a NetworkAware widget
        // to detect network state changes and show an error message if the
        // client is not connected to wifi.
        builder: (context, Widget child) => NetworkAware(child: child),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return FadeTransitionRoute(
                child: Splash(),
              );
            case '/home':
              return FadeTransitionRoute(
                child: Home(),
              );
            case '/setup':
              return NoTransitionRoute(
                builder: (_) => Setup(),
                settings: settings,
              );
            case '/account_setup':
              return FadeTransitionRoute(
                child: AccountSetup(),
              );
            case '/wifi_required':
              return NoTransitionRoute(
                builder: (_) => NoWifi(),
                settings: settings,
              );
            case '/connect':
              return NoTransitionRoute(
                builder: (_) => Connect(),
              );
            case '/connection_failed':
              return NoTransitionRoute(
                builder: (_) => ConnectionFailed(),
              );
            case '/add':
              return SlideTransitionRoute(
                page: Add(),
              );
            default:
              return null;
          }
        },

        // Add all supported locales here:
        supportedLocales: [const Locale('en', 'UK')],

        // Remove the bright red debug banner if we're in debug mode
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
