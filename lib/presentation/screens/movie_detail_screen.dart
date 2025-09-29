import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CustomScrollView allows for rich scrolling effects like the collapsing app bar.
      body: CustomScrollView(
        slivers: [
          // The collapsing app bar that shows the movie poster.
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true, // The app bar remains visible at the top when collapsed.
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(shadows: [Shadow(blurRadius: 4, color: Colors.black)]),
              ),
              // The background of the app bar, which includes multiple layers for a rich visual effect.
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Layer 1: A blurred version of the poster to fill the background on wide screens.
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: CachedNetworkImage(
                      imageUrl: movie.fullImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Layer 2: The main, non-cropped poster, centered.
                  CachedNetworkImage(
                    imageUrl: movie.fullImageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(color: Colors.black38),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black38,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_creation_outlined, color: Colors.white54, size: 50),
                          SizedBox(height: 8),
                          Text("Image not available", style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ),
                  ),
                  // Layer 3: A gradient at the bottom to make the title readable when the bar is expanded.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                  // Layer 4: A gradient at the top to make the back button and status bar icons visible.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.3],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // The main scrollable content of the screen.
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A row of info chips for rating and release date.
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 8.0,
                      children: [
                        _InfoChip(
                          icon: Icons.star_rounded,
                          label: '${movie.voteAverage.toStringAsFixed(1)} / 10',
                        ),
                        if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty)
                          _InfoChip(
                            icon: Icons.calendar_today_rounded,
                            label: DateFormat.yMMMMd().format(DateTime.parse(movie.releaseDate!)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // A row of action buttons (UI only, no functionality).
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(icon: Icons.play_arrow_rounded, label: 'Play'),
                        _ActionButton(icon: Icons.add_rounded, label: 'Watchlist'),
                        _ActionButton(icon: Icons.movie_rounded, label: 'Trailer'),
                        _ActionButton(icon: Icons.download_rounded, label: 'Download'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // The "Overview" section.
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 50), // Extra space at bottom for better scrolling
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets for this screen ---

/// A reusable chip with a frosted glass effect for displaying movie info.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Chip(
          avatar: Icon(icon, color: Colors.white70, size: 18),
          label: Text(label),
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }
}

/// A reusable action button with an icon and a label.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}