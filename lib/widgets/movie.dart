import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/movie.dart';
import 'package:movie_tracker_application/utils/routes.dart';

class MovieWidget extends StatelessWidget {
  final Movie movie;
  final Function deleteCallback;
  final Function refreshCallback;

  const MovieWidget({
    Key? key,
    required this.movie,
    required this.deleteCallback,
    required this.refreshCallback,
  }) : super(key: key);

  void onDeleteTap(context) async {
    await deleteCallback(movie.id);
    refreshCallback();
  }

  void onEditTap(context) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.editMovieRoute,
      arguments: {'movie': movie},
    );
    refreshCallback();
  }

  Widget posterImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: movie.posterImage != null
          ? Image.memory(
              movie.posterImage as Uint8List,
              height: 150,
              alignment: Alignment.topLeft,
            )
          : Image.asset(
              'assets/images/popcorn.png',
              height: 150,
              width: 100,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
    );
  }

  Widget button(
    MaterialColor backColor,
    IconData icon,
    BuildContext context,
    Function onTap,
    String text,
  ) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backColor),
        minimumSize: MaterialStateProperty.all(Size(100, 45)),
      ),
      onPressed: () => onTap(context),
      icon: Icon(
        icon,
        color: Colors.white,
        size: 20.0,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget deleteButton(BuildContext context) {
    return button(
      Colors.red,
      CupertinoIcons.delete_solid,
      context,
      onDeleteTap,
      "Delete",
    );
  }

  Widget editButton(BuildContext context) {
    return button(
      Colors.deepPurple,
      CupertinoIcons.archivebox_fill,
      context,
      onEditTap,
      "Edit",
    );
  }

  Widget actionButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        deleteButton(context),
        SizedBox(width: 10),
        editButton(context),
      ],
    );
  }

  Widget movieInfo(context) {
    return Container(
      constraints: BoxConstraints(minHeight: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.name as String,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Director: ${movie.director as String}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          actionButtons(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(0, 0),
            blurRadius: 2.0,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(0.0, 16.0),
            blurRadius: 32.0,
            spreadRadius: -4,
          ),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.only(right: 20),
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          posterImage(),
          SizedBox(width: 10),
          Expanded(child: movieInfo(context)),
        ],
      ),
    );
  }
}
