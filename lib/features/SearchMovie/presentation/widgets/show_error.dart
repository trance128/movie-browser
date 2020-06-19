import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  final String message;

  ShowError(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Text(
            '$message',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }
}
