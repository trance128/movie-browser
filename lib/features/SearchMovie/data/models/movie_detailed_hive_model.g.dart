// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detailed_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailedHiveAdapter extends TypeAdapter<MovieDetailedHive> {
  @override
  final typeId = 1;

  @override
  MovieDetailedHive read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailedHive(
      id: fields[0] as String,
      title: fields[1] as String,
      year: fields[2] as int,
      poster: fields[3] as String,
      plot: fields[4] as String,
      rated: fields[5] as String,
      released: fields[6] as DateTime,
      runTime: fields[7] as int,
      genre: fields[8] as String,
      director: fields[9] as String,
      writer: fields[10] as String,
      actors: fields[11] as String,
      language: fields[12] as String,
      awards: fields[13] as String,
      rating: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailedHive obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.poster)
      ..writeByte(4)
      ..write(obj.plot)
      ..writeByte(5)
      ..write(obj.rated)
      ..writeByte(6)
      ..write(obj.released)
      ..writeByte(7)
      ..write(obj.runTime)
      ..writeByte(8)
      ..write(obj.genre)
      ..writeByte(9)
      ..write(obj.director)
      ..writeByte(10)
      ..write(obj.writer)
      ..writeByte(11)
      ..write(obj.actors)
      ..writeByte(12)
      ..write(obj.language)
      ..writeByte(13)
      ..write(obj.awards)
      ..writeByte(14)
      ..write(obj.rating);
  }
}

