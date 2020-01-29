import 'dart:convert' show base64;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hive/hive.dart' show Hive;
import 'package:image_picker/image_picker.dart';

class AccountSetup extends StatefulWidget {
  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  static final AssetImage _image = AssetImage("assets/images/setup.png");

  // user-defined variables
  static FileImage _selected;
  static String _first, _last;

  @override
  Widget build(BuildContext context) {
    bool valid = _first != null && _last != null && _selected != null;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        leading: CupertinoButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: valid ? 1 : 0.2,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
              child: Text("Save", style: Theme.of(context).textTheme.button.copyWith(fontSize: 16)),
            ),
            onPressed: valid
                ? () async {
                    Hive.box<String>("preferences").put("username", "$_first $_last");
                    Hive.box<String>("preferences").put("picture", base64.encode(await _selected.file.readAsBytes()));

                    Navigator.of(context).pushReplacementNamed("/home");
                  }
                : null,
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 20),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ListView(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).buttonColor, width: 3),
                        image: DecorationImage(
                          image: _selected ?? _image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 160,
                      width: 160,
                    ),
                    onTap: () async {
                      _selected = FileImage(await ImagePicker.pickImage(source: ImageSource.gallery));

                      setState(() {
                        // Empty setState call since
                        // it can't contain a Future
                      });
                    },
                  ),
                ),
                TextField(
                  maxLength: 20,
                  maxLengthEnforced: true,
                  enableSuggestions: false,
                  autofocus: true,
                  autocorrect: false,
                  style: TextStyle(fontSize: 22),
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Theme.of(context).brightness,
                  decoration: InputDecoration(
                    helperText: "first name".toUpperCase(),
                    helperStyle: TextStyle(fontSize: 12, color: Theme.of(context).buttonColor.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim() == "") return;

                    setState(() => _first = value.trim());
                  },
                ),
                TextField(
                  maxLength: 20,
                  maxLengthEnforced: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: TextStyle(fontSize: 22),
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Theme.of(context).brightness,
                  decoration: InputDecoration(
                    helperText: "last name".toUpperCase(),
                    helperStyle: TextStyle(fontSize: 12, color: Theme.of(context).buttonColor.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim() == "") return;

                    setState(() => _last = value.trim());
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "By tapping \"Save\", you acknowledge that you have read the Privacy Policy and agree to the Terms of Service.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).buttonColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
