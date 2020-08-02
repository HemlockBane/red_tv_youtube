import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/screens/welcome.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'profile',
  'email',
]);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          RaisedButton(
            onPressed: _handleSignOut,
            child: Text(
              'sign out'.toUpperCase(),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('You are not signed in...'),
          RaisedButton(
            onPressed: _handleSignIn,
            child: Text(
              'sign in'.toUpperCase(),
            ),
          ),
        ],
      );
    }

    // return

    // Old Button click
    // Center(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 25.0),
    //     child: Container(
    //       width: double.infinity / 2,
    //       child: MaterialButton(
    //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    //         color: Colors.red[700],
    //         // color: Colors.red,
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: (context) {
    //               return WelcomeScreen(
    //                 title: 'Red TV Youtube',
    //               );
    //             }),
    //           );
    //         },
    //         child: Text(
    //           'Login',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> _handleSignOut() async {
  _googleSignIn.disconnect();
}
