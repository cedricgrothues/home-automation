import 'package:flutter/material.dart';

import 'package:home/components/regular_icons.dart';
import 'package:home/screens/home/add_device.dart';

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
                icon: new Icon(RegularIcons.home_lg_alt),
              ),
              Tab(
                icon: new Icon(RegularIcons.music_alt),
              ),
              Tab(
                icon: new Icon(RegularIcons.clouds_moon),
              ),
              Tab(
                icon: new Icon(RegularIcons.plus),
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
            AddDevice(),
          ],
        ),
      ),
    );
  }
}
