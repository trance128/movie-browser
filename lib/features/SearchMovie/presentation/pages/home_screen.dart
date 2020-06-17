import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/bloc/movie_search_bloc.dart';

import '../../../../injection_container.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  String input;

  void addSearchEvent() {
    BlocProvider.of<MovieSearchBloc>(context).add(SearchMovieEvent(input));
    Navigator.push(context, route)
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
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) => input = value,
                  onSubmitted: (_) => addSearchEvent,
                ),
                SizedBox(height: 20),
                FlatButton(
                  child: Text('Search'),
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
