import 'package:flutter/material.dart';
import 'package:flutter_movies/movie.dart';
import 'package:flutter_movies/movie_detail.dart';
import 'http_helper.dart';

void main() {
  runApp(MyMovies());
}

class MyMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MovieList();
  }
}

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  String result;
  HttpHelper helper;

  // Movies data
  int moviesCount;
  List<Movie> movies;

  // Search widgets for AppBar
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget>[
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (this.visibleIcon.icon == Icons.search) {
                  this.visibleIcon = Icon(Icons.cancel);
                  this.searchBar = TextField(
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    onSubmitted: (String text) {
                      search(text);
                    },
                  );
                } else {
                  setState(() {
                    this.visibleIcon = Icon(Icons.search);
                    this.searchBar = Text('Movies');
                    // Show initial upcoming movies
                    backToUpcoming();
                  });
                }
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: (moviesCount == null) ? 0 : moviesCount,
        itemBuilder: (BuildContext context, int position) {
          if (movies[position].posterPath != null) {
            debugPrint(iconBase + movies[position].posterPath);
            image = NetworkImage(iconBase + movies[position].posterPath);
          } else {
            image = NetworkImage(defaultImage);
          }
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(movies[position].title),
              subtitle: Text('Released: ' +
                  movies[position].releaseDate +
                  '-' +
                  'Vote: ' +
                  movies[position].voteAverage.toString()),
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (_) => MovieDetail(movies[position]));
                Navigator.push(context, route);
              },
            ),
          );
        },
      ),
    );
  }

  Future initialize() async {
    movies = List();
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future search(text) async {
    movies = await helper.findMovie(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future backToUpcoming() async {
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

}

