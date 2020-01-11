import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'package:home/components/button.dart';
import 'package:home/components/routes.dart';
import 'package:home/screens/home/home.dart';
import 'package:image_picker/image_picker.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({Key key, this.initial = 0}) : super(key: key);

  /// Set the PageViews initial page if the user
  /// hasn't finished the setup process yet.
  final int initial;

  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  PageController _controller;
  File _image;
  int _current;

  @override
  void initState() {
    // Initialize the PageController and _current in [initState]
    // to access the non-final widget.initial parameter
    _controller = PageController(initialPage: widget.initial, keepPage: true);
    _current = widget.initial ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // PageView with Content
          Positioned.fill(
            child: PageView(
              controller: _controller,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SetName(onSubmitted: (username) {
                  if (username == "") return;

                  Box<String> box = Hive.box<String>('preferences');
                  box.put("username", username);

                  _current++;

                  _controller.nextPage(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 600),
                  );
                }),
                SetImage(
                  onTap: () async {
                    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    if (_image == null) return;
                    setState(() {});

                    Box<String> box = Hive.box<String>('preferences');
                    box.put("picture", base64.encode(_image.readAsBytesSync()));
                  },
                  image: _image,
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 70,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Indicator(
                  active: _current < 1,
                ),
                Indicator(
                  active: _current >= 1,
                ),
              ],
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            child: Continue(controller: _controller, current: _current),
          ),
        ],
      ),

      // Disable resizing since we'll handle it ourselfs
      resizeToAvoidBottomInset: false,
    );
  }
}

class SetName extends StatelessWidget {
  final Function(String) onSubmitted;

  const SetName({Key key, @required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 60, left: 20, right: 20),
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Text(
              "Home Hub found! Let's get to know you a little better...",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          AnimatedPositioned(
            bottom: (MediaQuery.of(context).viewInsets.bottom != 0)
                ? MediaQuery.of(context).viewInsets.bottom + 50
                : MediaQuery.of(context).size.height / 2.2,
            left: 0,
            right: 0,
            child: TextField(
              maxLength: 32,
              maxLengthEnforced: true,
              enableSuggestions: false,
              autocorrect: false,
              style: TextStyle(fontSize: 22),
              keyboardType: TextInputType.text,
              keyboardAppearance: Theme.of(context).brightness,
              decoration: InputDecoration(
                hintText: "They call me...",
                hintStyle: TextStyle(fontSize: 22, color: Theme.of(context).buttonColor.withOpacity(0.4)),
                helperText: "Your name".toUpperCase(),
                helperStyle: TextStyle(fontSize: 12, color: Theme.of(context).buttonColor.withOpacity(0.2)),
                border: InputBorder.none,
              ),
              onSubmitted: onSubmitted,
            ),
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class SetImage extends StatelessWidget {
  final File image;
  final Function() onTap;

  const SetImage({Key key, this.image, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 60, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 6),
            constraints: BoxConstraints(maxWidth: 300),
            child: Text(
              "Hi, ${Hive.box<String>('preferences').get("username")}! Let's coose your profile picture...",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: onTap,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).buttonColor,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  maxRadius: 100,
                  minRadius: 80,
                  backgroundImage: image != null ? FileImage(image) : null,
                  //backgroundColor: Colors.red,
                  child: Text(Hive.box<String>('preferences').get("username")),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Continue extends StatelessWidget {
  final int current;
  final PageController controller;

  const Continue({Key key, @required this.current, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      child: Button(
        title: current < 1 ? "Continue" : "Let's get started!",
        onPressed: () {
          if (current < 1) {
            controller.nextPage(
              curve: Curves.ease,
              duration: Duration(milliseconds: 600),
            );
          } else {
            Navigator.of(context).pushReplacement(FadeTransitionRoute(child: Home()));
          }
        },
        width: MediaQuery.of(context).size.width - 150,
      ),
      opacity: 1,
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({Key key, @required this.active}) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: active ? 1 : 0.2,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).buttonColor,
        ),
      ),
      duration: Duration(milliseconds: 100),
    );
  }
}
