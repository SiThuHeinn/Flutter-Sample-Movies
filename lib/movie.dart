
class Movie{
  int id;
  String title;
  double voteAverage;
  String releaseDate;
  String overview;
  String posterPath;

  Movie(int id, String title, double voteAverage, String releaseDate, String overview, String posterPath){
    this.id = id;
    this.title = title;
    this.voteAverage = voteAverage;
    this.releaseDate = releaseDate;
    this.overview = overview;
    this.posterPath = posterPath;
  }

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.title = parsedJson['title'];
    this.voteAverage = parsedJson['vote_average'] * 1.0;
    this.releaseDate = parsedJson['release_date'];
    this.overview = parsedJson['overview'];
    this.posterPath = parsedJson['poster_path'];
  }


}