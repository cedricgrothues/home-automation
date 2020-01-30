import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hive/hive.dart' show Hive;

class AccountSetup extends StatefulWidget {
  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  static String _first, _last;

  @override
  Widget build(BuildContext context) {
    final valid = _first != null && _last != null;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        leading: CupertinoButton(
          child: Text(
            'Cancel',
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
              child: Text('Save', style: Theme.of(context).textTheme.button.copyWith(fontSize: 16)),
            ),
            onPressed: valid
                ? () {
                    Hive.box<String>('preferences').put('username', '$_first $_last');

                    Navigator.of(context).pushReplacementNamed('/home');
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
                    helperText: 'first name'.toUpperCase(),
                    helperStyle: TextStyle(fontSize: 12, color: Theme.of(context).buttonColor.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim() == '') return;

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
                    helperText: 'last name'.toUpperCase(),
                    helperStyle: TextStyle(fontSize: 12, color: Theme.of(context).buttonColor.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim() == '') return;

                    setState(() => _last = value.trim());
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'By tapping \"Save\", you acknowledge that you have read the Privacy Policy and agree to the Terms of Service.',
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
