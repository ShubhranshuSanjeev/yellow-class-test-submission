import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/movie.dart';
import 'package:movie_tracker_application/pages/add_movie_page.dart';
import 'package:movie_tracker_application/pages/edit_movie_page.dart';
import 'package:movie_tracker_application/pages/home_page.dart';
import 'package:movie_tracker_application/utils/routes.dart';
import 'package:movie_tracker_application/utils/themes.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MovieProvider? movieProvider;

  void initialize() async {
    MovieProvider _movieProvider = MovieProvider();
    await _movieProvider.setDB();

    setState(() {
      movieProvider = _movieProvider;
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.lightTheme(context),
      initialRoute: '/home',
      routes: {
        AppRoutes.homeRoute: (context) =>
            HomePage(movieProvider: movieProvider),
        AppRoutes.addMovieRoute: (context) =>
            AddMoviePage(movieProvider: movieProvider),
        AppRoutes.editMovieRoute: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, Movie>;
          return EditMoviePage(
            movieProvider: movieProvider,
            movie: args['movie'] as Movie,
          );
        }
      },
    );
  }
}
