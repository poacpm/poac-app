import 'package:flutter/material.dart';

class Pack extends StatelessWidget {
  final Map<String, dynamic> _package;

  Pack(this._package);

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
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Text(_package.containsKey('license') ? _package['license'] : 'none')),
          Container(
            margin: const EdgeInsets.all(16.0),
            child: _buildOwners(),
          ),
        ]));
  }

  Widget _buildOwners() {
    return ListView.builder(
      itemCount: _package['owners'].length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: Container( // CircleAvatar(child: Image.asset('')) // そのユーザidのアイコン
              width: 10.0,
              height: 10.0,
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              )
          ),
          title: Text(_package['owners'][index]),
        );
      },
      shrinkWrap: true,
    );
  }
}
