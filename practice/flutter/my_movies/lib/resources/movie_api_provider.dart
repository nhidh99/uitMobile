import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:my_movies/model/trailer_model.dart';
import 'dart:convert';
import '../model/item_model.dart';

class MovieApiProvider {
    Client client = Client();
    final _apiKey = 'e1208060be6fb22f5ed27c5557b8dfde';
    final _baseUrl = "http://api.themoviedb.org/3/movie";

    Future<ItemModel> fetchMovieList() async {
        final response = await client
            .get("http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey");
        if (response.statusCode == 200) {
            // If the call to the server was successful, parse the JSON
            return ItemModel.fromJson(json.decode(response.body));
        } else {
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
        }
    }

    Future<TrailerModel> fetchTrailer(int movieId) async {
        final response =
        await client.get("$_baseUrl/$movieId/videos?api_key=$_apiKey");

        if (response.statusCode == 200) {
            return TrailerModel.fromJson(json.decode(response.body));
        } else {
            throw Exception('Failed to load trailers');
        }
    }
}