// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHiveAdapter extends TypeAdapter<SearchHive> {
  @override
  final typeId = 0;

  @override
  SearchHive read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHive(
      title: fields[0] as String,
      found: fields[1] as bool,
      page: fields[2] as int,
      totalResults: fields[3] as int,
      results: (fields[4] as List)?.cast<MovieBrief>(),
    );
  }

  @override
  void write(BinaryWriter writer, SearchHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.found)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.totalResults)
      ..writeByte(4)
      ..write(obj.results);
  }
}
