import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poac/pages/signin.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                final String token = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/signin'),
                    builder: (BuildContext context) => Signin()
                  )
                );
                print(token);
                _signInWithGithub(token);
              },
//              onPressed: () async { _signInWithGithub(); },
              child: Row(
                children: <Widget>[
                  const Icon(FontAwesomeIcons.github),
                  const Text('Sign in with GitHub'),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      )
    );
  }

  void _signInWithGithub(String token) async {
    final AuthCredential credential = GithubAuthProvider.getCredential(
      token: token,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in with Github. ' + user.uid;
      } else {
        _message = 'Failed to sign in with Github. ';
      }
    });
  }
}
