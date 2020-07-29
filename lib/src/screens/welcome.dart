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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              /// ..Add your code here
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
