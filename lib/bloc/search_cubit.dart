import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _movieRepository;

  SearchCubit(this._movieRepository) : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    // Emit the loading state to show a progress indicator in the UI.
    emit(SearchLoading());
    try {
      // Fetch the movies from the repository.
      final movies = await _movieRepository.searchMovies(query);
      // Emit the loaded state with the fetched movies.
      emit(SearchLoaded(movies));
    } catch (e) {
      // If an error occurs (e.g., network failure), emit the error state.
      emit(SearchError("An error occurred: ${e.toString()}"));
    }
  }
}