import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/model/model.dart';
import 'package:movie_app/database/database.dart';
import 'package:movie_app/screens/web_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieView extends StatefulWidget {
  MovieView(this.movie);
  final Movie movie;

  @override
  MovieViewState createState() => MovieViewState();
}

class MovieViewState extends State<MovieView> {
  Movie movieState;
  Video v;
  String id,url;

  // https://www.youtube.com/watch?v=SUXWAEX2jlg
  //http://api.themoviedb.org/3/movie/550/videos?api_key=###
  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
    id = widget.movie.id;
    MovieDatabase db = MovieDatabase();
  /*  db.getMovie(movieState.id).then((movie) {
      setState(() => movieState.favored = movie.favored);
    });*/
  }



  void onPressed() {
    MovieDatabase db = MovieDatabase();
    setState(() => movieState.favored = !movieState.favored);
    movieState.favored == true
        ? db.addMovie(movieState)
        : db.deleteMovie(movieState.id);
  }

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
        initiallyExpanded: movieState.isExpanded ?? false,
        onExpansionChanged: (b) => movieState.isExpanded = b,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: RichText(
              text: TextSpan(
                text: movieState.overview,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          RaisedButton(
              child:Text("Watch Trailer",style:TextStyle(color:Colors.white)),
              onPressed: () async   {

                String watch = "Loading trailer in web view..!!";
                bool check = true;

                await http.get( 'https://api.themoviedb.org/3/movie/'+id+'/videos?api_key=KEY')
                    .then((res)=> (res.body))
                    .then(json.decode)
                    .then((map){
                      if(map["results"].toString()=='[]'){
                        watch= "Trailer not available";
                        check=false;
                      }
                    });

                Fluttertoast.showToast(
                    msg: watch,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 15.0
                );

                if(check) {
                  http
                      .get(
                      'https://api.themoviedb.org/3/movie/' + id +
                          '/videos?api_key=8728f6a74eee380d9a09090d6c6e3c2c')
                      .then((res) => (res.body))
                      .then(json.decode)
                      .then((map) => map["results"])
                      .then((v) => v.forEach(addMovie));
                }


              },
              color: Colors.blue,

          )
        ],
        leading: IconButton(
          icon: movieState.favored ? Icon(Icons.star) : Icon(Icons.star_border),
          color: Colors.blue,
          onPressed: () {
            Fluttertoast.showToast(
                msg: "Response saved successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15.0
            );
            onPressed();
          },
        ),
        title: Container(
            height: 200.0,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                movieState.posterPath != null
                    ? Hero(
                        child: Image.network(
                            "https://image.tmdb.org/t/p/w92${movieState.posterPath}"),
                        tag: movieState.id,
                      )
                    : Container(),
                    Expanded(
                        child: Text(
                          movieState.title,
                          textAlign: TextAlign.center,
                          maxLines: 10,
                        )
                    ),
              ],
            )
        )
    );
  }

  void addMovie(item) async  {
    setState(() {
      v = Video.fromJson(item);
      url = 'https://www.youtube.com/watch?v='+v.key;
    });
    await Navigator.of(context)
        .push(MaterialPageRoute<Map<String, String>>(
        builder: (BuildContext context) {
          return WebView(url,movieState.title);
        },
        fullscreenDialog: false
    )
    );
  }
}
