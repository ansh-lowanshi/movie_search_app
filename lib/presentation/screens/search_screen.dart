import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/search_cubit.dart';
import '../../bloc/search_state.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _lastQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce; // Timer for debouncing user input.

  /// Debounce logic to prevent excessive API calls.
  /// This function is called every time the user types in the search field.
  void _onSearchChanged(String query) {
    // If a timer is already active, cancel it.
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer. The search will only be performed after 500ms of inactivity.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _lastQuery = query;
        context.read<SearchCubit>().searchMovies(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Avatar, The Matrix...',
                filled: true,
                fillColor: Colors.white10,
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                    FocusScope.of(context).unfocus(); // Close the keyboard
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      // BlocBuilder handles rebuilding the UI in response to state changes from the SearchCubit.
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // Show initial view with an icon and prompt.
          if (state is SearchInitial) {
            return const _InitialView();
          }
          // Show a shimmer loading effect while fetching data.
          if (state is SearchLoading) {
            return const _LoadingView();
          }
          // Show an animated grid of movie cards when data is loaded.
          if (state is SearchLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('No movies found for that query.'));
            }
            return AnimationLimiter(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  final isPortrait = orientation == Orientation.portrait;
                  return GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPortrait ? 2 : 4,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      // Each grid item is animated as it appears on screen.
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: isPortrait ? 2 : 4,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: MovieCard(
                              movie: movie,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(movie: movie),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          // Show an error view with a retry button if something goes wrong.
          if (state is SearchError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<SearchCubit>().searchMovies(_lastQuery),
            );
          }
          return const SizedBox.shrink(); // Fallback for any other state
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources to prevent memory leaks when the screen is closed.
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

// --- Helper Widgets for different UI states ---

/// Widget to show when the screen is first opened.
class _InitialView extends StatelessWidget {
  const _InitialView();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_creation_outlined, size: 80, color: Colors.white38),
          SizedBox(height: 20),
          Text(
            'Find Your Next Favorite Movie',
            style: TextStyle(fontSize: 20, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

/// A shimmer loading effect widget that mimics the grid layout.
class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: OrientationBuilder(builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isPortrait ? 2 : 4,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: 8,
            itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
      }),
    );
  }
}

/// Widget to display an error message and a retry button.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.white54),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry'))
          ],
        ),
      ),
    );
  }
}