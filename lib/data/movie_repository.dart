import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'models/movie.dart';

class MovieRepository {
  // Read the API key from the loaded .env file
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? 'NO_API_KEY';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  /// Searches for movies based on a query string.
  ///
  /// Throws an [Exception] if the API key is not found or if the API call fails.
  Future<List<Movie>> searchMovies(String query) async {
    // If the query is empty, return an empty list to avoid an unnecessary API call.
    if (query.isEmpty) {
      return [];
    }

    // A crucial check to ensure the API key was loaded correctly from the .env file.
    if (_apiKey == 'NO_API_KEY') {
      throw Exception('API Key not found. Please check your .env file.');
    }

    // Construct the final URL for the API request.
    final uri = Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query');

    // Make the HTTP GET request.
    final response = await http.get(uri);

    // Check if the request was successful (HTTP status code 200).
    if (response.statusCode == 200) {
      // Decode the JSON response body.
      final decodedBody = json.decode(response.body);

      // Get the list of results from the JSON structure.
      final List<dynamic> results = decodedBody['results'];

      // Map the list of JSON objects to a list of Movie objects.
      final List<Movie> movies = results
          .map((jsonMovie) => Movie.fromJson(jsonMovie))
          .toList();
          
      return movies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception to be handled by the BLoC.
      throw Exception('Failed to load movies. Status code: ${response.statusCode}');
    }
  }
}