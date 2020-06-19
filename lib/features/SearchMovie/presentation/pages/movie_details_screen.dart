import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/movie_search_bloc/movie_search_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/pages/search_result_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const String routeName = '/details';

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
    return Center(
      child: Column(
        children: [
          Text('Details Loaded'),
          Text('${state.movieDetailed.id}'),
          Text('${state.movieDetailed.title}'),
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
    Navigator.of(context).pushNamed(SearchResultScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieSearchBloc>(context);

    return WillPopScope(
      onWillPop: () => _onBackPressed(context, bloc),
      child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => _onBackPressed(context, bloc),
            ),
            backgroundColor: Colors.blueGrey,
            elevation: 0,
            title: _buildTitle(state),
          ),
          body: _buildBody(context, bloc),
        ),
      ),
    );
  }
}
