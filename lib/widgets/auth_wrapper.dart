import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/custom_user.dart';
import 'package:movie_tracker_application/models/movie.dart';
import 'package:movie_tracker_application/pages/add_movie_page.dart';
import 'package:movie_tracker_application/pages/login_page.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  final MovieProvider? movieProvider;
  const AuthWrapper({Key? key, required this.movieProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null)
      return LoginPage();
    else
      return AddMoviePage(movieProvider: movieProvider);
  }
}
