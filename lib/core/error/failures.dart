import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  /// abstract class representing a failure object
  /// used to safely handle errors
  
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class ServerFailure extends Failure{}

class CacheFailure extends Failure{}

class NetworkFailure extends Failure{}