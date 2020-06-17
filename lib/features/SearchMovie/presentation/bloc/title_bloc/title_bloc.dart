import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class TitleBloc extends Bloc<TitleEvent, TitleState> {
  @override 
  TitleState get initialState => TitleState('');

  @override
  Stream<TitleState> mapEventToState(TitleEvent event) async* {
    if (event is SetTitleEvent) {
      yield TitleState(event.title);
    } else if (event is ResetTitleEvent) {
      yield TitleState('');
    }
  }
}

abstract class TitleEvent extends Equatable {
  final String title;

  const TitleEvent(this.title);

  @override
  List<Object> get props => [title];
}

class SetTitleEvent extends TitleEvent  {
  final String title;

  const SetTitleEvent(this.title) : super(title);

  @override
  List<Object> get props => [];
}

class ResetTitleEvent extends TitleEvent {
  const ResetTitleEvent() : super('');

  @override
  List<Object> get props => [super.title];
}

class TitleState extends Equatable {
  final String title;

  const TitleState(this.title);

  @override 
  List<Object> get props => [title];
}