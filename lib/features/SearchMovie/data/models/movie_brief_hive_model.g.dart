// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_brief_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieBriefHiveAdapter extends TypeAdapter<MovieBriefHive> {
  @override
  final typeId = 2;

  @override
  MovieBriefHive read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieBriefHive(
      id: fields[0] as String,
      title: fields[1] as String,
      year: fields[2] as int,
      poster: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieBriefHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.poster);
  }
}
