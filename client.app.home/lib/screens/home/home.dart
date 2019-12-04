import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:home/screens/home/addons/devices.dart';

import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            FutureProvider.value(
              value: Devices.fetch(),
              child: Devices(),
            )
          ],
        ),
      ),
    );
  }
}

// class Scene extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 240,
//       height: 70,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Theme.of(context).cardColor,
//       ),
//       alignment: Alignment.bottomLeft,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "Bedroom Lamp",
//               style: Theme.of(context).textTheme.body2.copyWith(fontSize: 16),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
