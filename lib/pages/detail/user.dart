import 'package:flutter/material.dart';

class User extends StatelessWidget {
  final String _userId;

  User(this._userId);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(_userId),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Text(_userId),
          ),
        ]
      )
    );
  }
}
