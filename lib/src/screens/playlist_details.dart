import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/screens/movie_screen.dart';
import 'package:red_tv_youtube/src/screens/welcome.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  @override
  _PlaylistDetailsScreenState createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {


  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double height = 0;
  @override
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      // key: _scaffoldKey,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                _buildGradient(context),
                buildColumn(context),
              ],
            ),
            _buildBottomButton()
          ],
        ),
      ),
    );
  }

  Widget buildColumn(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: height / 2,
            ),
            Text(
              "The Men's Club".toUpperCase(),
              style: _textStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            Text("Season 3".toUpperCase(),
                style: _textStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w300)),
            SizedBox(
              height: 30,
            ),
            Text("Synopsis",
                style: _textStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 11,
            ),
            Text(
                "The men's club takes us on a journey of 4 friends surrounded by women,"
                "business and the hassles of the city.\n\nWhen a group of middle-aged friends "
                "gets together to talk about various aspects of their lives, the gathering gradually turns into a drunken party. "
                "Kicked out of their cozy domestic environment by an irate wife, the men.",
                style: _textStyle()),
            SizedBox(
              height: 31,
            ),
            Text(
              "Cast",
              style:
                  _textStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Baaj Adebule, Ayoola Ayolola, Efa Iwara",
              style: _textStyle(),
            ),
            SizedBox(
              height: 23,
            ),
            Container(
              margin: EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ratings',
                        style: _textStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '9.3/10',
                        style: _textStyle(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Duration',
                        style: _textStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '25 mins',
                        style: _textStyle(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Genre',
                        style: _textStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Drama',
                        style: _textStyle(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Column(
      children: <Widget>[
        Spacer(),
        Material(
          color: Color(0xFFBA0000),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return MovieScreen();
                }),
              );
            },
            child: Container(
              height: 55,
              width: double.infinity,
              child: Center(
                  child: Text(
                'Watch Full Season',
                style: _textStyle(fontSize: 18, color: Colors.white),
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradient(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F3F3F47), Color(0xFF3F3F3F)],
            tileMode: TileMode.repeated,
            stops: [0.3, 0.6]),
      ),
    );
  }

  TextStyle _textStyle(
      {Color color,
      double fontSize = 15,
      FontWeight fontWeight = FontWeight.normal}) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
        color: color ?? Color(0xFFC0C0C0),
        fontSize: fontSize,
        fontWeight: fontWeight);
  }
}
