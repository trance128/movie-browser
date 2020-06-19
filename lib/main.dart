import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/SearchMovie/presentation/bloc/movie_search_bloc/movie_search_bloc.dart';
import 'features/SearchMovie/presentation/pages/home_screen.dart';
import 'features/SearchMovie/presentation/pages/movie_details_screen.dart';
import 'features/SearchMovie/presentation/pages/search_result_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieSearchBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Movie Browser",
        home: HomeScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          SearchResultScreen.routeName: (context) => SearchResultScreen(),
          MovieDetailsScreen.routeName: (context) => MovieDetailsScreen(),
        },
      ),
    );
  }
}
