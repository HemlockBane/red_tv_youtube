import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/screens/welcome.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/red_tv.jpg'),
          ),
          SizedBox(height: 15),
          Center(
            child: MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
              color: Colors.red[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return WelcomeScreen(
                      title: 'Red TV Youtube',
                    );
                  }),
                );
              },
              child: Text(
                'Login'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
