import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/SearchMovie/presentation/bloc/bloc/movie_search_bloc.dart';
import 'features/SearchMovie/presentation/pages/home_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movie Browser",
      home: BlocProvider(
        create: (_) => sl<MovieSearchBloc>(),
        child: HomeScreen(),
      ),
    );
  }
}
