import 'dart:io'; // Required for SocketException
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _movieRepository;

  SearchCubit(this._movieRepository) : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    // We don't want to show loading for an empty query
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final movies = await _movieRepository.searchMovies(query);
      emit(SearchLoaded(movies));
    } on SocketException {
      // Specifically catch the no-internet error
      emit(const SearchError("No Internet Connection.\nPlease check your network and try again."));
    } catch (e) {
      // Catch all other errors
      emit(SearchError("Could not process your request: ${e.toString()}"));
    }
  }
}