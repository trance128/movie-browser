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
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              child: Image(
                image: NetworkImage(
                    'https://kpmfilm.com/wp-content/uploads/2017/11/The-Movie-Studio-green-screen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.grey.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            _buildMainContent(context, addSearchEvent),
          ],
        ),
      ),
    );
  }
}

Widget _buildMainContent(BuildContext context, Function callback) {
  double screenSize = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;

  return Center(
    child: Column(
      children: [
        Container(
          height: screenSize * .4,
          alignment: Alignment.bottomCenter,
          child: Text(
            'Movie\nCatalogue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenSize * .05),
        SearchBox(),
        SizedBox(height: screenSize * .05),
        FlatButton(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.search, color: Colors.white),
            width: MediaQuery.of(context).size.width * .2,
          ),
          onPressed: callback,
          color: Colors.blueGrey[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ],
    ),
  );
}
