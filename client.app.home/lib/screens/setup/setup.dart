import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:home/components/button.dart';

import 'package:url_launcher/url_launcher.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 3),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/setup.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).buttonColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 70, horizontal: 70),
                    child: Text(
                      "All your smart speakers, lamps, and more controlled from one app, with location, time and temperature based scenes. All to ensure the best smart home experience possible.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle.copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ),
                  Button(
                    title: "Connect to an existing system",
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/connect');
                    },
                    width: MediaQuery.of(context).size.width - 150,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Need help? ',
                      style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Visit the FAQ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                          recognizer: new TapGestureRecognizer()..onTap = help,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void help() =>
      launch("https://589b62795c79fff2fee9152874dc3dfcf6381ef6:@github.com/cedricgrothues/home-automation/blob/master/README.md");
}
