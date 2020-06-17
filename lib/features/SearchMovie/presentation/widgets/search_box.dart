import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/bloc/movie_search_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/pages/search_result_page.dart';

class SearchBox extends StatefulWidget {
  final bool small;

  SearchBox({this.small = false});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController controller = TextEditingController();
  String input;

  void searchTitle() {
    BlocProvider.of<MovieSearchBloc>(context).add(SearchMovieEvent(input));
    Navigator.of(context).pushNamed(SearchResultPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onChanged: (value) => input = value,
      onSubmitted: (_) => searchTitle,
    );
  }
}
