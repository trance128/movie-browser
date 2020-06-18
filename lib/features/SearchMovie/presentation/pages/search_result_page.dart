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
  MovieSearchBloc bloc;

  void addSearchEvent(MovieSearchBloc bloc) {
    bloc.add(SearchMovieEvent());
    Navigator.of(context).pushNamed(SearchResultPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MovieSearchBloc>(context);

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
            onPressed: () => addSearchEvent(bloc),
          )
        ],
      ),
      body: BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) {
          print('before the if statements');
          if (state is MovieSearchInitial) {
            print('Moviesearcchinitial');
            return Container();
          } else if (state is SearchLoading) {
            print('loading');
            return CircularProgressIndicator();
          } else if (state is SearchLoaded) {
            print('loaded');
            return _buildLoadedState(context, state);
          } else {
            return Container(child: Text('State is $state'));
          }
        },
      ),
    );
  }

  @override
  dispose() {
    bloc.close();
    super.dispose();
  }
}

// Widget _buildBody(BuildContext context, MovieSearchBloc bloc) {
//   final state = bloc.state;

//   if (state is MovieSearchInitial) {
//     print('Moviesearcchinitial');
//     return Container();
//   } else if (state is SearchLoading) {
//     print('loading');
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   } else if (state is SearchLoaded) {
//     print('loaded');
//     return ListView.builder(itemBuilder: null);
//   } else {
//     return Container(child: Text('State is $state'));
//   }
// }

Widget _buildLoadedState(BuildContext context, SearchLoaded state) {
  print('loaded state');
  return Column(
    children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
          itemCount: state.searchResult.results.length,
          itemBuilder: (BuildContext ctx, int index) {
            final MovieBriefHive item = state.searchResult.results[index];
            return ListTile(
              leading:
                  Image(fit: BoxFit.cover, image: NetworkImage(item.poster)),
              title: Text(item.title),
              subtitle: Text('${item.year}'),
            );
          },
        ),
      ),
    ],
  );
}
