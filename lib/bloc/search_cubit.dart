import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  // Dependency on MovieRepository to fetch data. This is injected.
  final MovieRepository _movieRepository;

  // The initial state is set to SearchInitial when the Cubit is created.
  SearchCubit(this._movieRepository) : super(SearchInitial());

  /// Fetches movies based on the user's query.
  Future<void> searchMovies(String query) async {
    // If the query is empty, return to the initial state.
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Emit loading state to notify the UI to show a progress indicator.
    emit(SearchLoading());
    try {
      // Call the repository to get the movie data.
      final movies = await _movieRepository.searchMovies(query);
      // Emit loaded state with the fetched data.
      emit(SearchLoaded(movies));
    } on SocketException {
      // Specifically catch network errors to show a user-friendly message.
      emit(const SearchError("No Internet Connection.\nPlease check your network and try again."));
    } catch (e) {
      // Catch any other errors during the process.
      emit(SearchError("Could not process your request: ${e.toString()}"));
    }
  }
}