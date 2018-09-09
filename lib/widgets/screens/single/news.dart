import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/news.dart';
import 'package:flutter_app/utils.dart';
import 'package:flutter_app/widgets/screens/single/photo.dart';
import 'package:http/http.dart' as http;

class ViewNewsPostScreen extends StatefulWidget {
  final NewsPost newsPost;

  final Function favStateCallback;

  ViewNewsPostScreen(this.newsPost, this.favStateCallback);

  @override
  State<StatefulWidget> createState() =>
      ViewNewsPostScreenState(newsPost, favStateCallback);
}

class ViewNewsPostScreenState extends State<ViewNewsPostScreen> {
  NewsPost newsPost;
  NewsAuthor author;
  bool _fav;

  Function favStateCallback;

  ViewNewsPostScreenState(NewsPost newsPost, Function favStateCallback) {
    this.newsPost = NewsPost(
        newsPost.title,
        newsPost.content,
        newsPost.photoUrl.replaceAll("&blur", ""),
        newsPost.postId,
        newsPost.authorId,
        favorite: newsPost.favorite);

    _fav = newsPost.favorite;

    author = new NewsAuthor(newsPost.authorId, "", "", "");

    this.favStateCallback = favStateCallback;
  }

  Future loadAuthor() async {
    String authorUrl = "https://jsonplaceholder.typicode.com/users/${newsPost
            .authorId}";

    http.Response response = await http.get(authorUrl);

    var rawAuthor = json.decode(response.body);

    setState(() {
      author = new NewsAuthor(newsPost.authorId, rawAuthor["name"],
          rawAuthor["username"], rawAuthor["email"]);
    });
  }

  @override
  void initState() {
    super.initState();

    loadAuthor();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onHorizontalDragEnd: (params) {
          if (params.velocity.pixelsPerSecond.dx > 0) {
            Navigator.pop(context);
          }
        },
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(newsPost.title),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(_fav ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _fav = !_fav;
                    if (_fav) {
                      addFavorite(newsPost.postId);
                    } else {
                      removeFavorite(newsPost.postId);
                    }
                    favStateCallback(newsPost.postId, _fav);
                  });
                },
              )
            ],
          ),
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                  height: 300.0,
                  color: Colors.grey[200],
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new ViewPhotoScreen(newsPost.photoUrl)));
                    },
                    child: new Image.network(
                      newsPost.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  )),
              new Container(
                margin: new EdgeInsets.all(8.0),
                child: new Text(
                  newsPost.title,
                  style: new TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: new Text(
                  newsPost.content,
                  style: new TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                ),
              ),
              new Container(
                decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(color: Colors.grey[300]))),
              ),
              new Container(
                margin: new EdgeInsets.all(8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(bottom: 8.0),
                      child: new Text(
                        "Author",
                        style: new TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                    ),
                    new Row(
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ViewPhotoScreen(
                                        author.avatarUrl
                                            .replaceAll("small", "big"))));
                          },
                          child: new CircleAvatar(
                            backgroundImage: new NetworkImage(author.avatarUrl),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 8.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                author.name,
                              ),
                              new Text(
                                "@${author
                                                                .username}",
                                style: new TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
