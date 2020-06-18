import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_search_bloc/movie_search_bloc.dart';
import '../pages/search_result_page.dart';

class SearchBox extends StatefulWidget {
  final bool small;

  SearchBox({this.small = false});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  void searchTitle(Bloc bloc) {
    bloc.add(SearchMovieEvent());
    Navigator.of(context).pushNamed(SearchResultPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieSearchBloc>(context);

    return TextField(
      controller: TextEditingController(text: bloc.getTitle),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onChanged: (value) => bloc.add(TitleChangedEvent(value)),
      onSubmitted: (_) => searchTitle(bloc),
    );
  }
}
