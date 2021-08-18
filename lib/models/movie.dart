import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Movie {
  int? id;
  String? name;
  String? director;
  Uint8List? posterImage;

  Movie();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'name': name,
      'director': director,
      'posterImage': posterImage
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  Movie.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    name = map['name'] as String?;
    director = map['director'] as String?;
    posterImage = map['posterImage'] as Uint8List?;
  }
}

class MovieProvider {
  Database? db;

  Future setDB() async {
    String databasesPath = await getDatabasesPath();
    db = await openDatabase(join(databasesPath, 'yc_sub.db'), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE movie ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, director TEXT, posterImage BLOB ) ');
    });
  }

  Future<Movie> insert(Movie movie) async {
    movie.id = await db!.insert('movie', movie.toMap());
    return movie;
  }

  Future<List<Movie>> getMovies() async {
    List<Map<String, Object?>> maps = await db!
        .query('movie', columns: ['id', 'name', 'director', 'posterImage']);

    List<Movie> movies = [];
    if (maps.length > 0) {
      maps.forEach((map) => movies.add(Movie.fromMap(map)));
    }

    return movies;
  }

  Future<Movie?> getMovie(int id) async {
    List<Map<String, Object?>> maps = await db!.query('movie',
        columns: ['id', 'name', 'director', 'posterImage'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) return Movie.fromMap(maps.first);

    return null;
  }

  Future<int?> delete(int id) async {
    return await db!.delete('movie', where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> update(Movie movie) async {
    return await db!
        .update('movie', movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
  }

  Future close() async => db!.close();
}
