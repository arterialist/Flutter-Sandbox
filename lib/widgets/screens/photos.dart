import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screens/single/photo.dart';

class PhotoCard extends StatefulWidget {
  final String _link;

  @override
  State<StatefulWidget> createState() => PhotoCardState(_link);

  PhotoCard(this._link);
}

class PhotoCardState extends State<PhotoCard>
    with SingleTickerProviderStateMixin {
  var _link;

  PhotoCardState(this._link);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
          margin: new EdgeInsets.all(4.0),
          color: Colors.grey[300],
          child: new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ViewPhotoScreen(_link)));
            },
            child: new Image.network(
              _link,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}

class PhotosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 3,
      children: new List.generate(30, (index) {
        return new PhotoCard(
            "https://picsum.photos/600/900/?image=${new Random()
                        .nextInt(1084)}");
      }),
    );
  }
}
