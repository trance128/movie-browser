import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_brief_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/movie_search_bloc/movie_search_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/widgets/search_box.dart';

import '../../../../injection_container.dart';

class SearchResultPage extends StatefulWidget {
  static const routeName = '/results';

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  void addSearchEvent() {
    BlocProvider.of<MovieSearchBloc>(context).add(SearchMovieEvent());
    Navigator.of(context).pushNamed(SearchResultPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBox(small: true),
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        actions: [
          FlatButton(
            child: Container(
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            onPressed: addSearchEvent,
          )
        ],
      ),
      body: _buildBody(context),
    );
  }
}

BlocProvider<MovieSearchBloc> _buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<MovieSearchBloc>(),
    child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) {
      if (state is MovieSearchInitial) {
        return Container();
      } else if (state is SearchLoading) {
        return CircularProgressIndicator();
      } else if (state is SearchLoaded) {
        return ListView.builder(itemBuilder: null);
      }
    }),
  );
}

Widget _buildLoadedState(BuildContext context, SearchLoaded state) {
  return Column(
    children: [
      ListView.builder(
        itemCount: state.searchResult.results.length,
        itemBuilder: (BuildContext ctx, int index) {
          final MovieBriefHive item = state.searchResult.results[index];
          return ListTile(
            leading: Image(fit: BoxFit.cover, image: NetworkImage(item.poster)),
            title: Text(item.title),
            subtitle: Text('${item.year}'),
          );
        },
      ),
    ],
  );
}
