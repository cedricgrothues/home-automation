import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';

import 'package:home/screens/wifi.dart';
import 'package:home/screens/splash.dart';
import 'package:home/screens/home/home.dart';
import 'package:home/screens/setup/setup.dart';
import 'package:home/screens/add/discover.dart';
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

    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Open Sans',
        buttonColor: Colors.black,
        canvasColor: Colors.transparent,
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
          backgroundColor: const Color(0xFFFEFEFE),
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
        dividerTheme: DividerThemeData(color: Colors.black, thickness: 2),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        toggleButtonsTheme: const ToggleButtonsThemeData(
          fillColor: Color(0xFFEEEEEF),
          color: Color(0xFF828287),
        ),
        splashFactory: const NoSplashFactory(),
        cardColor: const Color(0xFFFFFFFF),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 24,
            color: const Color(0xFF121112),
            fontWeight: FontWeight.w600,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          subtitle2: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          headline6: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 19,
          ),
          bodyText1: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: Colors.black,
          ),
          caption: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9A9A9E),
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFF000001),
        fontFamily: 'Open Sans',
        buttonColor: Colors.white,
        canvasColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 26,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF191d23),
          thickness: 1.5,
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
        toggleButtonsTheme: const ToggleButtonsThemeData(
          fillColor: Color(0xFF313135),
          color: Color(0xFFA1A1A8),
        ),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: const NoSplashFactory(),
        cardColor: const Color(0xFF191d23),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          button: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          subtitle2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          headline6: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 19,
          ),
          bodyText1: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: Colors.white,
          ),
          caption: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C8C91),
          ),
          subtitle1: TextStyle(
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
            return FadeTransitionRoute<Splash>(
              child: Splash(),
            );
          case '/home':
            return FadeTransitionRoute<Home>(
              child: Home(),
            );
          case '/setup':
            return NoTransitionRoute<Setup>(
              builder: (_) => Setup(),
              settings: settings,
            );
          case '/account_setup':
            return FadeTransitionRoute<AccountSetup>(
              child: AccountSetup(),
            );
          case '/wifi_required':
            return NoTransitionRoute<NoWifi>(
              builder: (_) => NoWifi(),
              settings: settings,
            );
          case '/connect':
            return NoTransitionRoute<Connect>(
              builder: (_) => Connect(),
            );
          case '/connection_failed':
            return NoTransitionRoute<ConnectionFailed>(
              builder: (_) => ConnectionFailed(),
            );
          case '/discover':
            return NoTransitionRoute<Discover>(
              builder: (_) => Discover(),
              settings: settings,
            );
          default:
            return null;
        }
      },

      // Add all supported locales here:
      supportedLocales: const [Locale('en', 'UK')],

      // Remove the bright red debug banner if we're in debug mode
      debugShowCheckedModeBanner: false,
    );
  }
}
