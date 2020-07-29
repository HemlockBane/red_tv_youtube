import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 55,
              ),

              /// ..Add your code here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Color(0xFFCACACA),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildPopularNowSection(),
              _buildExclusivesSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularNowSection() {
    return Container();
  }

  Widget _buildExclusivesSection() {
    return Container();
  }
}
