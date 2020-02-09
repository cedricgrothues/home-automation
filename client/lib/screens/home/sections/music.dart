import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicControl extends StatefulWidget {
  @override
  _MusicControlState createState() => _MusicControlState();
}

class _MusicControlState extends State<MusicControl> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _playing = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://m.media-amazon.com/images/I/81OYhSN4WFL._SS500_.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Rooftops',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Flexible(
                                  child: Text(
                                    'Calbrxwn',
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white24,
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.more_horiz, color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TODO: Update these items to reseamble the Apple Music app
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CupertinoButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.skip_previous,
                    size: 50,
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    _playing ? _controller.reverse() : _controller.forward();
                    _playing = !_playing;
                  },
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _controller,
                    size: 60,
                  ),
                ),
                CupertinoButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.skip_next,
                    size: 50,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.volume_down,
                      size: 20,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.white54,
                          inactiveTrackColor: Colors.white24,
                        ),
                        child: Slider(
                          value: 1,
                          onChanged: (d) => null,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.volume_down,
                      size: 20,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
