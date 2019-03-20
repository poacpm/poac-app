import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final Map<String, dynamic> _package;

  Detail(this._package);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(_package['name']),
        ),
        body: ListView(children: [
          Row(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 16.0),
                child: Text(_package['name'])),
            Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: Text(_package['version'])),
          ]),
          Container(
              margin: const EdgeInsets.all(16.0),
              child: Text(_package['description'])),
//          Container(
//              margin: const EdgeInsets.all(16.0),
//              child: Text(_package['license'])),
        ]));
  }
}
