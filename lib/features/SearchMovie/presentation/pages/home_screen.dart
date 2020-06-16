import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/features/SearchMovie/presentation/bloc/bloc/movie_search_bloc.dart';

import '../../../../injection_container.dart';

class HomeScreen extends StatelessWidget {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
