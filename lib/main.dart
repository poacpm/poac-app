import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:poac/pack.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'poac',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'poac'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AlgoliaIndexReference packagesRef = Application.algolia.instance.index('packages');
  List packages = new List();

  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);

  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Package Searcher');


  _MyHomePageState() {
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
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
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
