import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

class ViewPhotoScreen extends StatelessWidget {
  final _link;

  @override
  Widget build(BuildContext context) {
    return new DecoratedBox(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Positioned(
            child: new GestureDetector(
              onTap: () {},
              onHorizontalDragEnd: (params) {},
              onVerticalDragEnd: (params) {
                Navigator.pop(context);
              },
              child: new Image.network(
                _link,
                fit: BoxFit.contain,
              ),
            ),
          ),
          new Positioned(
            child: new FloatingActionButton(
              onPressed: () async {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  AndroidIntent intent =
                      new AndroidIntent(action: "action_view", data: _link);
                  await intent.launch();
                }
              },
              child: new Icon(Icons.language),
            ),
            bottom: 16.0,
            right: 16.0,
          )
        ],
      ),
    );
  }

  ViewPhotoScreen(this._link);
}
