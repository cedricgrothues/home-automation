import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Home".toUpperCase(),
                style: Theme.of(context).textTheme.headline,
              ),
              Column(
                children: <Widget>[
                  CupertinoButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      color: Theme.of(context).buttonColor,
                      child: Text(
                        "Connect to an existing system",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: CupertinoButton(
                      child: Text(
                        "Learn more about Home",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
