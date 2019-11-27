import 'package:flutter/material.dart';

import 'package:home/components/regular_icons.dart';

class ConnectionFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                RegularIcons.heart_broken,
                size: 40,
                color: Theme.of(context).buttonColor,
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "Home could not connect to device-registry service. Please ensure it is plugged in and online, then try again.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle.copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
