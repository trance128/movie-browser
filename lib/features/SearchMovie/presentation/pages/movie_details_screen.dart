import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/movie_search_bloc/movie_search_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/pages/search_result_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const String routeName = '/details';

  final double titleShadowOffset = 0.7;
  final Color titleShadowColor = Colors.white;

  final double sideShadowOffset = 0.1;
  final Color sideShadowColor = Colors.white;

  TextStyle _sideTextstyle() {
    return TextStyle(
      fontSize: 18,
      color: Colors.grey[900],
      fontWeight: FontWeight.w600,
      shadows: [
        ..._buildShadow(sideShadowOffset, sideShadowColor),
      ],
      fontStyle: FontStyle.italic,
    );
  }

  List<Shadow> _buildShadow(offset, color) {
    return [
      Shadow(
        offset: Offset(offset, offset),
        color: color,
      ),
      Shadow(
        offset: Offset(offset, -offset),
        color: color,
      ),
      Shadow(
        offset: Offset(-offset, offset),
        color: color,
      ),
      Shadow(
        offset: Offset(-offset, -offset),
        color: color,
      ),
    ];
  }

  Container _buildInfoOnSides(
    BuildContext context,
    dynamic info1,
    dynamic info2,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 1,
            ),
            child: Text(
              '$info1',
              style: _sideTextstyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 1,
            ),
            child: Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                '$info2',
                style: _sideTextstyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _buildTitle(MovieSearchState state) {
    if (state is DetailsLoaded) {
      return Text('${state.movieDetailed.title}');
    } else if (state is DetailsLoading) {
      return Text('Loading');
    } else if (state is DetailsError) {
      return Text('Something has gone wrong');
    }

    // this won't run, but I want to silence the warning
    return Text('');
  }

  Widget _buildBody(BuildContext context, MovieSearchBloc bloc) {
    final state = bloc.state;

    if (state is DetailsLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is DetailsLoaded) {
      return _buildLoaded(context, state);
    } else if (state is DetailsError) {
      return _buildError(context);
    } else {
      return Center(
        child: _buildError(context),
      );
    }
  }

  Widget _buildLoaded(BuildContext context, DetailsLoaded state) {
    final MovieDetailedHive details = state.movieDetailed;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage('${details.poster}'),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.96),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '${details.title}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        ..._buildShadow(titleShadowOffset, titleShadowColor),
                      ],
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                _buildInfoOnSides(
                  context,
                  details.year,
                  details.language,
                ),
                _buildInfoOnSides(
                  context,
                  '${details.runTime} min',
                  details.rated,
                ),
                _buildInfoOnSides(
                  context,
                  '${details.rating}/100',
                  details.genre,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    details.plot,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Text(
            'Something\nhas gone wrong',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.red[900],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Plese try again later',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context, MovieSearchBloc bloc) {
    bloc.add(SearchMovieEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieSearchBloc>(context);

    return WillPopScope(
      onWillPop: () => _onBackPressed(context, bloc),
      child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              double.infinity,
              50,
            ),
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => _onBackPressed(context, bloc),
              ),
              backgroundColor: Colors.blueGrey,
              elevation: 0,
              title: _buildTitle(state),
            ),
          ),
          body: _buildBody(context, bloc),
        ),
      ),
    );
  }
}
