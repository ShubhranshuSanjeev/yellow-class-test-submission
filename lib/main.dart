import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/custom_user.dart';
import 'package:movie_tracker_application/models/movie.dart';

import 'package:movie_tracker_application/pages/edit_movie_page.dart';
import 'package:movie_tracker_application/pages/home_page.dart';
import 'package:movie_tracker_application/pages/login_page.dart';

import 'package:movie_tracker_application/services/auth.dart';

import 'package:movie_tracker_application/utils/routes.dart';
import 'package:movie_tracker_application/utils/themes.dart';

import 'package:movie_tracker_application/widgets/auth_wrapper.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: MyTheme.lightTheme(context),
        initialRoute: '/home',
        routes: {
          AppRoutes.loginRoute: (context) => LoginPage(),
          AppRoutes.homeRoute: (context) =>
              HomePage(movieProvider: movieProvider),
          AppRoutes.addMovieRoute: (context) =>
              AuthWrapper(movieProvider: movieProvider),
          // AddMoviePage(movieProvider: movieProvider),
          AppRoutes.editMovieRoute: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, Movie>;
            return EditMoviePage(
              movieProvider: movieProvider,
              movie: args['movie'] as Movie,
            );
          }
        },
      ),
    );
  }
}
