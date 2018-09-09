import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/models/news.dart';
import 'package:flutter_app/widgets/screens/favorites.dart';
import 'package:flutter_app/widgets/screens/home.dart';
import 'package:flutter_app/widgets/screens/news.dart';
import 'package:flutter_app/widgets/screens/photos.dart';
import 'package:flutter_app/widgets/screens/settings.dart';

void main() {
  // ignore: deprecated_member_use
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Flutter Demo",
      initialRoute: "/",
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentPage = 2;

  List<int> favorites = [1, 2, 5, 13, 16, 42, 54, 67];

  Map<int, Widget> screens = {};

  Widget getBody() {
    return screens[_currentPage];
  }

  void refreshFavorites(int postId, bool fav) {
    setState(() {
      if (fav) {
        favorites.add(postId);
      } else {
        favorites.removeWhere((id) => id == postId);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    screens = {
      0: FavoritesScreen(
          new NewsFilter(shouldBeFavorite: true, favs: favorites),
          refreshFavorites),
      1: NewsScreen(new NewsFilter(favs: favorites), refreshFavorites),
      2: HomeScreen(),
      3: PhotosScreen(),
      4: SettingsScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarItem createItem(
        IconData icon, String title, Color color) {
      return new BottomNavigationBarItem(
          backgroundColor: color,
          icon: new Icon(icon),
          title: new Text(
            title,
            style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Demo"),
      ),
      body: getBody(),
      bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _currentPage,
          onTap: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          items: [
            createItem(Icons.star, "Favorites", Colors.amber),
            createItem(Icons.format_list_bulleted, "News", Colors.lightBlue),
            createItem(Icons.home, "Home", Colors.green),
            createItem(Icons.photo_library, "Photos", Colors.teal),
            createItem(Icons.settings, "Settings", Colors.blueGrey),
          ]),
    );
  }
}
