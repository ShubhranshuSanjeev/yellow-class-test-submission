import 'package:flutter/material.dart';
import 'package:movie_tracker_application/models/movie.dart';
import 'package:movie_tracker_application/widgets/drawer.dart';
import 'package:movie_tracker_application/widgets/movie.dart';

class HomePage extends StatefulWidget {
  final MovieProvider? movieProvider;
  HomePage({Key? key, required this.movieProvider}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];

  void getData() async {
    if (widget.movieProvider != null) {
      List<Movie> _movies = await widget.movieProvider!.getMovies();
      setState(() {
        movies = _movies;
      });
    }
  }

  void handleDelete(int id) async {
    if (widget.movieProvider != null) {
      await widget.movieProvider!.delete(id);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  void refereshData() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Tracker"),
      ),
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieWidget(
              movie: movies[index],
              deleteCallback: handleDelete,
              refreshCallback: refereshData,
            );
          },
        ),
      ),
      drawer: MyDrawer(callback: refereshData),
    );
  }
}
