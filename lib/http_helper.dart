import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_movies/movie.dart';
import 'package:http/http.dart' as http;

class HttpHelper {

  // It's a bad habit to store the const strings here.
  final String urlKey = 'api_key=[YOUR API KEY]';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-Us';
  final String urlSearchBase = 'https://api.themoviedb.org/3/search/movie?api_key=[YOUR API KEY]&query=';


  Future<List<Movie>> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;

    http.Response result = await http.get(Uri.parse(upcoming));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];

      List<Movie> movies = List();
      moviesMap.map((i) {
        movies.add(Movie(
            i['id'], i['title'], i['vote_average'] * 1.0, i['release_date'],
            i['overview'], i['poster_path']));
      }).toList();
      return movies;
    } else {
      return null;
    }
  }


  Future<List<Movie>> findMovie(String title) async {
    final String query = urlSearchBase + title;
    http.Response response = await http.get(Uri.parse(query));
    if (response.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(response.body);
      final moviesMap = jsonResponse['results'];
      debugPrint('Search Raw Result -> $moviesMap');

      List<Movie> searchedMovies = List();
      moviesMap.map((i){
        debugPrint('Single Raw Result -> $i');
        searchedMovies.add(Movie(
            i['id'], i['title'], i['vote_average'] * 1.0, i['release_date'],
            i['overview'], i['poster_path']));
          }
      ).toList();

      debugPrint('Search Result -> ${searchedMovies.length}');
      return searchedMovies;
    }else{
     return null;
    }
  }

}