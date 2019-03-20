import 'package:flutter/material.dart';

class Package extends StatelessWidget {
  final Map<String, dynamic> _package;

  Package(this._package);

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
            child: Text(
                _package.containsKey('license') ? _package['license'] : 'none'
            )
          ),
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
          leading: CircleAvatar(
              radius: 15.0,
              backgroundImage:
                NetworkImage(
                  'https://avatars2.githubusercontent.com/u/26405363?v=4' // そのユーザidのアイコン
                ),
              backgroundColor: Colors.transparent,
          ),
          title: Text(_package['owners'][index]),
        );
      },
      shrinkWrap: true,
    );
  }
}
