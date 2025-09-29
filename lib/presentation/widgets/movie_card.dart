import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';

// This is a StatefulWidget to handle the state of the tap animation.
class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap; // Callback for navigation when the card is tapped.

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    // AnimatedScale provides a smooth scaling transition on tap.
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: _isTapped ? 0.95 : 1.0, // Scale down when tapped, otherwise scale is normal.
      curve: Curves.easeOut,
      child: GestureDetector(
        // Manage the tapped state for the animation.
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: widget.onTap, // Trigger the navigation callback.
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            children: [
              // Layer 1: The poster image.
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.movie.fullImageUrl,
                    placeholder: (context, url) => Container(color: Colors.black26),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Layer 2: A gradient overlay to make the title readable against any image.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Layer 3: The movie title.
              Positioned(
                bottom: 12,
                left: 10,
                right: 10,
                child: Text(
                  widget.movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1, 1))]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}