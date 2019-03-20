import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:poac/pack.dart';

class Home extends StatefulWidget {
  Home() : super();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AlgoliaIndexReference packagesRef = Application.algolia.instance.index('packages');
  List packages = new List();

  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);

  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Package Searcher');


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
    this._getPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[ _buildBar(context) ];
          },
          body: _buildList(),
        )
    );
  }

  Widget _buildBar(BuildContext context) {
    return new SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(packages[index]['name']),
          subtitle: Text(
            packages[index]['description'],
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(packages[index]['version']),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute<Null>(
                settings: const RouteSettings(name: "/pack"),
                builder: (BuildContext context) => new Pack(packages[index])
            ));
          },
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search packages'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Package Searcher');
        _filter.clear();
      }
    });
  }

  void _getPackages() async {
    AlgoliaQuerySnapshot snap = await packagesRef.search(this._searchText).getObjects();
    List tempList = new List();
    for (int i = 0; i < snap.hits.length; i++) {
      tempList.add(snap.hits[i].data);
    }
    setState(() {
      packages = tempList;
    });
  }
}

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'IOCVK5FECM',
    apiKey: '9c0a76bacf692daa9e8eca2aaff4b2ab',
  );
}
