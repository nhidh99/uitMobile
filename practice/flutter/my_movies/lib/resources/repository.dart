import 'dart:async';
import 'package:my_movies/model/trailer_model.dart';
import 'movie_api_provider.dart';
import '../model/item_model.dart';

class Repository {
    final moviesApiProvider = MovieApiProvider();
    Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
    Future<TrailerModel> fetchTrailers(int movieId) => moviesApiProvider.fetchTrailer(movieId);
}