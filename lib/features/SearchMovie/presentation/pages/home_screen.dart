import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_search_bloc/movie_search_bloc.dart';
import '../widgets/search_box.dart';
import 'search_result_page.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  String input;

  void addSearchEvent() {
    BlocProvider.of<MovieSearchBloc>(context).add(SearchMovieEvent());
    Navigator.of(context).pushNamed(SearchResultPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: Text(
                    'Movie Catalogue',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SearchBox(),
                SizedBox(height: 20),
                FlatButton(
                  child: Icon(Icons.search),
                  onPressed: addSearchEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
