import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bloc/search_cubit.dart';
import 'data/movie_repository.dart';
import 'presentation/screens/search_screen.dart';

Future<void> main() async {
  // Load the .env file
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We provide the repository and cubit at the top of the widget tree.
    return RepositoryProvider(
      create: (context) => MovieRepository(),
      child: BlocProvider(
        create: (context) => SearchCubit(
          context.read<MovieRepository>(),
        ),
        child: MaterialApp(
          title: 'Movie Search App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            primaryColor: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const SearchScreen(),
        ),
      ),
    );
  }
}