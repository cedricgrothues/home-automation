import 'package:flutter/material.dart';
import 'package:home/components/regular_icons.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: TabBar(
            tabs: [
              Tab(
                icon: new Icon(RegularIcons.thermometer_three_quarters),
              ),
              Tab(
                icon: new Icon(RegularIcons.music_alt),
              ),
              Tab(
                icon: new Icon(RegularIcons.plus),
              ),
              Tab(
                icon: new Icon(RegularIcons.clouds_moon),
              ),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black12,
            indicator: UnderlineTabIndicator(),
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
