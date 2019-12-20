import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home/components/button.dart';

class AccountSetup extends StatefulWidget {
  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        middle: Text(
          "Home nickname & address",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                      "Your home nickname helps you identify your home. The address will be used for things such as location based routines and directions.",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ),
                  TextField(),
                  TextField(),
                ],
              ),
              Opacity(
                child: Button(
                  title: "Finish Setup",
                  onPressed: null,
                  width: MediaQuery.of(context).size.width - 150,
                ),
                opacity: 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
