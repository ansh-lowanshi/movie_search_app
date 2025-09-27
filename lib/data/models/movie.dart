class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath; // Can be null from the API

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
  });

  // A factory constructor to create a Movie from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }

  // A helper getter to build the full image URL
  String get fullImageUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750.png?text=No+Image';
}