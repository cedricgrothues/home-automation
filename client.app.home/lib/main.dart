import 'package:flutter/material.dart';
import 'package:home/screens/setup.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Open Sans',
        buttonColor: Colors.black,
        textTheme: TextTheme(
          headline: TextStyle(
            fontSize: 35,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          subtitle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Open Sans',
        buttonColor: Colors.white,
        textTheme: TextTheme(
          headline: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          button: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          subtitle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Setup(),
        '/setup': (context) => Setup(),
      },
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
    );
  }
}
