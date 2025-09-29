import 'package:equatable/equatable.dart';
import '../data/models/movie.dart';

// Base abstract class for all search-related states.
// Using Equatable allows for easy comparison of state objects to avoid unnecessary rebuilds.
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

// Represents the initial state before any search is performed.
class SearchInitial extends SearchState {}

// Represents the state when data is being fetched from the API.
class SearchLoading extends SearchState {}

// Represents a successful data fetch, containing the list of movies for the grid.
class SearchLoaded extends SearchState {
  final List<Movie> movies;

  const SearchLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

// Represents an error state, containing a message to show to the user.
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}