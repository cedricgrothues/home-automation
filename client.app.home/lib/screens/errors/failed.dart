import 'package:flutter/material.dart';
import 'package:home/components/button.dart';

import 'package:home/components/regular_icons.dart';

class ConnectionFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 70, horizontal: 70),
                child: Text(
                  "Home could not connect to the device-registry service. Please ensure it is plugged in and online, then try again.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle.copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ),
              Button(
                title: "Retry",
                onPressed: () {
                  print("Retrying...");
                },
                width: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
