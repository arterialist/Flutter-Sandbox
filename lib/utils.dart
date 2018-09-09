import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Future<List<int>> getFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var favoritesRaw = prefs.getStringList("KEY_FAVORITES") ?? [];

  List<int> favorites = [];
  favoritesRaw.forEach((str) => () {
        favorites.add(int.parse(str));
      });

  return favorites;
}

void addFavorite(int postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favorites = [];

  var favoritesRaw = await getFavorites();
  favoritesRaw.add(postId);
  favoritesRaw.forEach((item) => () {
        favorites.add(item.toString());
      });

  await prefs.setStringList("KEY_FAVORITES", favorites);
}

void removeFavorite(int postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favorites = [];

  var favoritesRaw = await getFavorites();
  favoritesRaw.remove(postId);
  favoritesRaw.forEach((item) => () {
        favorites.add(item.toString());
      });

  await prefs.setStringList("KEY_FAVORITES", favorites);
}
