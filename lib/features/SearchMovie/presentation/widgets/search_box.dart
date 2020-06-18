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
    final size = MediaQuery.of(context).size;

    if (widget.small) {
      return Container(
        width: double.infinity,
        height: size.height * .05,
        child: TextField(
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          controller: TextEditingController(text: bloc.getTitle),
          onChanged: (value) => bloc.add(TitleChangedEvent(value)),
          onSubmitted: (_) => searchTitle(bloc),
        ),
      );
    }

    return Container(
      width: size.width * .9,
      height: size.height * 0.07,
      child: TextField(
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        controller: TextEditingController(text: bloc.getTitle),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        onChanged: (value) => bloc.add(TitleChangedEvent(value)),
        onSubmitted: (_) => searchTitle(bloc),
      ),
    );
  }
}
