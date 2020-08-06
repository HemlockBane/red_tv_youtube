import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/notifiers/exclusives_playlist.dart';
import 'package:red_tv_youtube/src/notifiers/popular_now.dart';
import 'package:red_tv_youtube/src/notifiers/red_tv.dart';
import 'package:red_tv_youtube/src/screens/login.dart';
import 'package:red_tv_youtube/src/screens/welcome.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExclusivesPlaylistNotifier()),
        ChangeNotifierProvider(create: (_) => PopularNowNotifier()),
        ChangeNotifierProvider(create: (_) => RedTVChannelNotifier()),
      ],
      child: MaterialApp(
        title: 'Red TV Youtube',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
