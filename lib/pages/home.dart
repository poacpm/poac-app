import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

import 'package:poac/config.dart';
import 'package:poac/pages/detail/package.dart';
import 'package:poac/pages/drawers/account.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AlgoliaIndexReference packagesRef = Config.algolia.instance.index('packages');
  List packages = List();
  String _searchText = "";
  Icon _searchIcon = Icon(Icons.search);
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = Text('poac', style: TextStyle(fontFamily: 'VarelaRound'));

  _HomeState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
      _getPackages();
    });
  }

  @override
  void initState() {
    _getPackages();
    super.initState();
  }

  void _getPackages() async {
    AlgoliaQuerySnapshot snap = await packagesRef.search(_searchText).getObjects();
    List tempList = List();
    for (int i = 0; i < snap.hits.length; i++) {
      tempList.add(snap.hits[i].data);
    }
    setState(() {
      packages = tempList;
    });
  }

  void _setAppBar() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _appBarTitle = TextField(
          cursorColor: Colors.black,
          controller: _filter,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search packages',
            hintStyle: TextStyle(color: Colors.black54),
            labelStyle: TextStyle(color: Colors.black54),
          ),
        );
      } else {
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text('poac', style: TextStyle(fontFamily: 'VarelaRound'));
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[ _buildBar(context) ];
        },
        body: _buildList(),
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildBar(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      centerTitle: true,
      elevation: 5.0,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _setAppBar,
        ),
      ],
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0
          ),
          title: Text(packages[index]['name']),
          subtitle: Text(
            packages[index]['description'],
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(packages[index]['version']),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(
                settings: const RouteSettings(name: "/package"),
                builder: (BuildContext context) => new Package(packages[index])
            ));
          },
        );
      },
    );
  }

  Widget _buildDrawer() {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 80.0,
            child: const DrawerHeader(
              child: const Text(
                  'poac', style: TextStyle(fontFamily: 'VarelaRound')
              ),
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 16.0, 0.0),
            ),
          ),
          const Divider(color: Colors.black),
          _buildDrawerMenu(Icons.person, 'Account', Account()),
          _buildDrawerMenu(Icons.settings, 'Settings', Account()),
          _buildDrawerMenu(Icons.feedback, 'Send a feedback', Account()),
        ],
      ),
    );
  }

  Widget _buildDrawerMenu<T extends Widget>(IconData icon, String name, T obj) {
    return new ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blueGrey),
          Container(margin: const EdgeInsets.only(left: 20.0)),
          Text(name, style: const TextStyle(color: Colors.blueGrey)),
        ],
      ),
      onTap: () {
        // Update the state of the app
        // Then close the drawer
        Navigator.pop(context);
        Navigator.push(context, new MaterialPageRoute(
            settings: RouteSettings(name: '/' + name.toLowerCase()),
            builder: (BuildContext context) => obj
        ));
      },
    );
  }
}
