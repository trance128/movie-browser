import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_brief_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/movie_search_bloc/movie_search_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/pages/movie_details_screen.dart';
import 'package:movie_browser/features/SearchMovie/presentation/widgets/search_box.dart';
import 'package:movie_browser/features/SearchMovie/presentation/widgets/show_error.dart';

class SearchResultScreen extends StatefulWidget {
  static const routeName = '/results';

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  MovieSearchBloc bloc;
  double appBarSize = 50;

  void addSearchEvent(MovieSearchBloc bloc) {
    bloc.add(SearchMovieEvent());
    Navigator.of(context).pushNamed(SearchResultScreen.routeName);
  }

  Widget _appBar(BuildContext context, MovieSearchBloc bloc, Function callback,
      double appBarSize) {
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarSize),
      child: AppBar(
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
            onPressed: () => callback(bloc),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, MovieSearchBloc bloc) {
    /// Builds the page body.  Needs context and bloc passed in
    /// First builds listview containing all results from bloc
    /// then, when appropraite, shows circualr progress indicator
    /// or error
    final state = bloc.state;
    List<MovieBriefHive> _searchResultList = bloc.getResultsList;

    if (_searchResultList.length == 0 || state is SearchError) {
      return Column(
        children: [
          if (state is SearchLoading) CircularProgressIndicator(),
          if (state is SearchError) ShowError(state.message),
        ],
      );
    }
    return Column(
      children: [
        Container(
          height: state is SearchLoaded
              ? MediaQuery.of(context).size.height * 0.89 -
                  MediaQuery.of(context).viewInsets.bottom
              : MediaQuery.of(context).size.height * 0.77 -
                  MediaQuery.of(context).viewInsets.bottom,
          child: _buildResultList(context, _searchResultList),
        ),
        if (state is SearchLoading) CircularProgressIndicator(),
      ],
    );
  }

  void _loadMoreResults() {
    print('how you doing');
    bloc.add(SearchMovieMoreResultsEvent());
  }

  Widget _buildResultList(BuildContext context, List<MovieBriefHive> list) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreResults();
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext ctx, int index) {
                  final MovieBriefHive item = list[index];
                  return _buildItem(item, bloc);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(MovieBriefHive item, MovieSearchBloc bloc) {
    return GestureDetector(
      onTap: () {
        bloc.add(GetMovieDetailsEvent(item.id));
        Navigator.of(context).pushNamed(MovieDetailsScreen.routeName);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 170,
          width: double.infinity,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                child: Container(
                  height: double.infinity,
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width * .3,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(item.poster),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .56,
                      child: Text(
                        item.title,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('${item.year}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MovieSearchBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: _appBar(context, bloc, addSearchEvent, appBarSize),
      body: BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) => _buildBody(
          context,
          bloc,
        ),
      ),
    );
  }
}
