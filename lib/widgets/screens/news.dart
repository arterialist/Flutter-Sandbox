import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/news.dart';
import 'package:flutter_app/utils.dart';
import 'package:flutter_app/widgets/screens/single/news.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatelessWidget {
  final NewsFilter filter;

  final Function favStateCallback;

  NewsScreen(this.filter, this.favStateCallback);

  @override
  Widget build(BuildContext context) {
    return new NewsList(filter, favStateCallback);
  }
}

class NewsList extends StatefulWidget {
  final NewsFilter filter;

  final Function favStateCallback;

  NewsList(this.filter, this.favStateCallback);

  @override
  State<StatefulWidget> createState() =>
      new NewsListState(filter, favStateCallback);
}

class NewsListState extends State<NewsList> {
  var news = [];
  NewsFilter filter;
  Function favStateCallback;

  NewsListState(this.filter, this.favStateCallback);

  Future loadNews() async {
    String newsUrl = "https://jsonplaceholder.typicode.com/posts";

    http.Response response = await http.get(newsUrl);
    var rawNews = json.decode(response.body);
    setState(() {
      for (var value in rawNews) {
        var post = new NewsPost(
            capitalize(value["title"]),
            capitalize(value["body"]),
            "https://picsum.photos/900/600/?image=${value["id"]}&blur",
            value["id"],
            value["userId"],
            favorite: filter.favs.contains(value["id"]));
        if (filter.matches(post)) {
          news.add(post);
        }
      }
    });
  }

  Widget createPostWidget(NewsPost newsItem) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new ViewNewsPostScreen(newsItem, favStateCallback)));
      },
      child: new Container(
        height: 300.0,
        decoration: new BoxDecoration(
            border:
                new Border(bottom: new BorderSide(color: Colors.grey[300]))),
        padding: new EdgeInsets.all(4.0),
        margin: new EdgeInsets.all(4.0),
        child: new Stack(
          children: <Widget>[
            new Positioned.fill(
                child: new Container(
              decoration: new BoxDecoration(color: Colors.grey[300]),
              child: new Image.network(
                newsItem.photoUrl,
                fit: BoxFit.cover,
              ),
            )),
            new Positioned(
              child: newsItem.favorite
                  ? new Icon(
                      Icons.star,
                      color: Colors.white,
                    )
                  : new Container(),
              top: 16.0,
              right: 16.0,
            ),
            new Positioned(
              child: new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(colors: [
                  Colors.black.withAlpha(128),
                  Colors.transparent
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                child: new Container(
                    padding: new EdgeInsets.all(16.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          newsItem.title,
                          maxLines: 2,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        new Text(newsItem.content,
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Colors.grey[300],
                              fontSize: 16.0,
                            ))
                      ],
                    )),
              ),
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new ListView.builder(
        itemCount: news.length,
        itemBuilder: (BuildContext context, int index) {
          return createPostWidget(news[index]);
        },
      );
    }
  }
}
