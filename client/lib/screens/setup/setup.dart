import 'dart:io' show Socket, SocketException;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'package:pedantic/pedantic.dart' show unawaited;
import 'package:url_launcher/url_launcher.dart' show launch;

import 'package:home/components/button.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Hero(
                      tag: 'image',
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 250,
                          maxWidth: 250,
                        ),
                        width: MediaQuery.of(context).size.height * 0.35,
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/setup.png',
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
                    Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        'All your smart speakers, lamps, and more controlled from one app, with location, time and temperature based scenes. All to ensure the best smart home experience possible.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button(
                      title: 'Connect to an existing system',
                      onPressed: () async {
                        try {
                          await Socket.connect('hub.local', 4000)
                            ..destroy();

                          // Socket.connect did not throw an Exception, so we can assume that
                          // the hub is online and available

                          unawaited(Navigator.of(context).pushReplacementNamed('/account'));
                        } on SocketException {
                          // SocketException are thrown if `hub.local` was not found
                          // with in the device's network.

                          unawaited(Navigator.of(context).pushReplacementNamed('/connection_failed'));
                        }
                      },
                      width: MediaQuery.of(context).size.width - 150,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Need help? ',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Visit the FAQ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()..onTap = help,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void help() => launch('https://github.com/cedricgrothues/home-automation/blob/master/README.md');
}
