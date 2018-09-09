import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screens/news.dart';

class FavoritesScreen extends StatelessWidget {
  final newsFilter;

  final favStateCallback;

  FavoritesScreen(this.newsFilter, this.favStateCallback);

  @override
  Widget build(BuildContext context) {
    return new NewsList(newsFilter, favStateCallback);
  }
}
