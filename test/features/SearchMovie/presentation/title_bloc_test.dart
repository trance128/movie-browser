import 'package:bloc_test/bloc_test.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/title_bloc/title_bloc.dart';

main() {
  String title = "Ovidius Is Awesome";

  blocTest(
    'Should start with an empty title',
    build: () async => TitleBloc(),
    skip: 0,
    expect: [
      TitleState(''),
    ],
  );

  blocTest(
    '[SetTitleEvent] updates title correctly',
    build: () async => TitleBloc(),
    act: (bloc) => bloc.add(SetTitleEvent(title)),
    expect: [
      TitleState(title),
    ],
  );

  blocTest(
    '[ResetTitleEvent] resets title correctly',
    build: () async => TitleBloc(),
    act: (bloc) {
      bloc.add(SetTitleEvent(title));
      return bloc.add(ResetTitleEvent());
    },
    skip: 0,
    expect: [
      TitleState(''),
      TitleState(title),
      TitleState(''),
    ]
  );
}
