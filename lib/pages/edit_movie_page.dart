import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/movie.dart';
import 'package:movie_tracker_application/widgets/movie_form.dart';

class EditMoviePage extends StatelessWidget {
  final MovieProvider? movieProvider;
  final Movie movie;

  const EditMoviePage({
    Key? key,
    required this.movieProvider,
    required this.movie,
  }) : super(key: key);

  void handleFormSubmit(
    BuildContext context,
    String name,
    String director,
    Uint8List? posterImage,
  ) async {
    movie.name = name;
    movie.director = director;
    if (posterImage != null) {
      movie.posterImage = posterImage;
    }

    if (movieProvider != null) {
      await movieProvider!.update(movie);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovieForm(
      name: movie.name,
      director: movie.director,
      posterImage: movie.posterImage,
      buttonText: "Edit & Save",
      onSubmit: handleFormSubmit,
    );
  }
}
