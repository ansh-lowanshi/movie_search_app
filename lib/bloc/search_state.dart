import 'package:equatable/equatable.dart';
import '../data/models/movie.dart'; // Make sure to import your Movie model

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

// Initial State: The screen is first loaded, nothing has happened yet.
class SearchInitial extends SearchState {}

// Loading State: We've started a search and are waiting for API results.
class SearchLoading extends SearchState {}

// Loaded State: The API call was successful and we have a list of movies to display.
class SearchLoaded extends SearchState {
  final List<Movie> movies;

  const SearchLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

// Error State: The API call failed for some reason.
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}