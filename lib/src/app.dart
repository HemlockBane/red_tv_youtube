import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/screens/welcome.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red TV Youtube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
