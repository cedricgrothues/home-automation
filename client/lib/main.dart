import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';

import 'src/screens/wifi.dart';
import 'src/screens/splash.dart';
import 'src/screens/add/brand.dart';
import 'src/screens/home/home.dart';
import 'src/screens/setup/setup.dart';
import 'src/screens/errors/failed.dart';
import 'src/screens/setup/account.dart';
import 'src/screens/settings/settings.dart';

import 'src/components/routes.dart';
import 'src/components/splash.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Locks the device orientation to a portrait up position.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        dialogBackgroundColor: const Color(0xFFf1f2f6),
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
          backgroundColor: const Color(0xFFFFFFFF),
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
        cardColor: const Color(0xFFF1F2F6),
        errorColor: const Color(0x33FC5B57),
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
        dialogBackgroundColor: const Color(0xFF0c1016),
        scaffoldBackgroundColor: const Color(0xFF000000),
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
        cardColor: const Color(0xFF1b1c1e),
        errorColor: const Color(0x33FC5B57),
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
            height: 1.1,
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

      // Set the initial route to `/` to make sure Hive is initialized.
      initialRoute: '/',

      // Every child is wrapped in a NetworkAware widget to detect
      // network state changes and show an error message if the
      // user is not connected to WiFi.
      builder: (context, Widget child) => NetworkAware(child: child),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return FadeTransitionRoute<void>(
              child: Splash(),
            );
          case '/home':
            return FadeTransitionRoute<void>(
              child: Home(),
            );
          case '/setup':
            return NoTransitionRoute<void>(
              builder: (_) => Setup(),
              settings: settings,
            );
          case '/account':
            return FadeTransitionRoute<void>(
              child: AccountSetup(),
            );
          case '/wifi_required':
            return NoTransitionRoute<void>(
              builder: (_) => NoWifi(),
              settings: settings,
            );
          case '/connection_failed':
            return FadeTransitionRoute<void>(
              child: ConnectionFailed(),
            );
          case '/choose_brand':
            return SlideTransitionRoute<void>(
              child: SelectBrand(),
            );
          case '/settings':
            return SlideTransitionRoute<void>(
              child: Settings(),
            );
          default:
            return null;
        }
      },

      // All supported locales
      supportedLocales: const [Locale('en', 'US')],

      // Hide the bright red debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
