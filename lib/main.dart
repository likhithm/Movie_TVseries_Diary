import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/screens/favorites.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Data Source: \"The Movie Database (TMDb)\"",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 15.0
                      );
                    }
                )
              ],
              title: Text("Movie Diary"),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.home),
                    text: 'Home Page',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite),
                    text: "Favorites",
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                HomePage(),
                Favorites(),
              ],
            ),
          ),
        )
    );
  }
}
