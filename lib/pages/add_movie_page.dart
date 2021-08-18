import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/movie.dart';
import 'package:movie_tracker_application/widgets/movie_form.dart';

class AddMoviePage extends StatelessWidget {
  final MovieProvider? movieProvider;

  const AddMoviePage({Key? key, required this.movieProvider}) : super(key: key);

  void handleFormSubmit(BuildContext context, String name, String director,
      Uint8List? posterImage) async {
    Movie newMovie = Movie();
    newMovie.name = name;
    newMovie.director = director;
    if (posterImage != null) {
      newMovie.posterImage = posterImage;
    }

    if (movieProvider != null) {
      await movieProvider!.insert(newMovie);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovieForm(
      onSubmit: handleFormSubmit,
      buttonText: "Add to List",
    );
  }
}
