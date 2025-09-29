import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'bloc/search_cubit.dart';
import 'data/movie_repository.dart';
import 'presentation/screens/search_screen.dart';

// --- Define a professional color scheme ---
const kPrimaryColor = Color(0xFFF2C94C); // A vibrant, film-like yellow
const kBackgroundColor = Color(0xFF121212); // A deep, rich black
const kSurfaceColor = Color(0xFF1E1E1E); // A slightly lighter black for cards

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MovieRepository(),
      child: BlocProvider(
        create: (context) => SearchCubit(context.read<MovieRepository>()),
        child: MaterialApp(
          title: 'Movie Search App',
          theme: ThemeData(
            // --- Apply the new theme ---
            brightness: Brightness.dark,
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kBackgroundColor,
            cardColor: kSurfaceColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
              // Ensure titles and body text are styled well
              titleLarge: const TextStyle(color: Colors.white),
              bodyMedium: const TextStyle(color: Colors.white70),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: kBackgroundColor,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.black,
              ),
            ),
            chipTheme: ChipThemeData(
              backgroundColor: kPrimaryColor.withOpacity(0.1),
              labelStyle: const TextStyle(color: kPrimaryColor),
            ),
          ),
          home: const SearchScreen(),
        ),
      ),
    );
  }
}