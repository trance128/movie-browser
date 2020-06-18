import 'package:flutter/material.dart';
import 'package:movie_browser/features/SearchMovie/presentation/widgets/search_box.dart';

class SearchResultPage extends StatefulWidget {
  static const routeName = '/results';

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBox(small: true),
        elevation: 0,
        actions: [
          // FlatButton(
          //   child: Icon(Icons.search),
          //   onPressed: SearchBox.searchTitle(),
          // )
        ],
      ),
    );
  }
}
