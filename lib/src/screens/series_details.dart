import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:red_tv_youtube/src/notifiers/red_tv.dart';
import 'package:red_tv_youtube/src/screens/movie_screen.dart';
import 'package:red_tv_youtube/src/screens/video_screen.dart';
// import 'package:red_tv_youtube/src/screens/welcome.dart';

class SeriesDetailsScreen extends StatefulWidget {
  final Playlist series;

  SeriesDetailsScreen({this.series});

  @override
  _SeriesDetailsScreenState createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final imageSeries = 'assets/images/the_menn.jpg';

  double height = 0;
  bool isLoadingPlaylistItems = true;

  /// Index of playlist Red TV's list of playlists
  int playlistIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final redTV = RedTVChannelNotifier.of(context);
      playlistIndex = redTV.playlists.indexOf(widget.series);
      await redTV.getPlaylistItems(playlist: widget.series);
      setState(() {
        isLoadingPlaylistItems = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height,
                  child: Image.network(
                    widget.series.standardThumbnail.isValid
                        ? widget.series.standardThumbnail.url
                        : widget.series.defaultThumbnail.url,
                    fit: BoxFit.cover,
                  ),
                ),
                _buildGradient(context),
                _buildColumn(context),
              ],
            ),
            _buildBottomButton()
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context) {
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
              widget.series.title.toUpperCase(),
              style: _textStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            // Text("Season 3".toUpperCase(),
            //     style: _textStyle(
            //         color: Colors.white,
            //         fontSize: 26,
            //         fontWeight: FontWeight.w300)),
            // SizedBox(
            //   height: 30,
            // ),
            if (widget.series.description.isNotEmpty)
              Text(
                "Synopsis",
                style: _textStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            SizedBox(
              height: 11,
            ),

            if (widget.series.description.isNotEmpty)
              Text(
                widget.series.description,
                style: _textStyle(),
              ),
            SizedBox(
              height: 31,
            ),
            // Text(
            //   "Cast",
            //   style:
            //       _textStyle(color: Colors.white, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(
            //   height: 6,
            // ),
            // Text(
            //   "Baaj Adebule, Ayoola Ayolola, Efa Iwara",
            //   style: _textStyle(),
            // ),
            // SizedBox(
            //   height: 23,
            // ),
            // Container(
            //   margin: EdgeInsets.only(right: 30),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             'Ratings',
            //             style: _textStyle(
            //                 color: Colors.white, fontWeight: FontWeight.bold),
            //           ),
            //           SizedBox(
            //             height: 6,
            //           ),
            //           Text(
            //             '9.3/10',
            //             style: _textStyle(),
            //           ),
            //         ],
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             'Duration',
            //             style: _textStyle(
            //                 color: Colors.white, fontWeight: FontWeight.bold),
            //           ),
            //           SizedBox(
            //             height: 6,
            //           ),
            //           Text(
            //             '25 mins',
            //             style: _textStyle(),
            //           ),
            //         ],
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             'Genre',
            //             style: _textStyle(
            //                 color: Colors.white, fontWeight: FontWeight.bold),
            //           ),
            //           SizedBox(
            //             height: 6,
            //           ),
            //           Text(
            //             'Drama',
            //             style: _textStyle(),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            Text(
              "Episodes",
              style:
                  _textStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 11,
            ),
            Selector<RedTVChannelNotifier, List<PlaylistItem>>(
              selector: (context, redTV) =>
                  redTV.playlists[playlistIndex].filteredItems,
              builder: (context, items, __) {
                // print('series_details - $items');
                if (isLoadingPlaylistItems) {
                  return Center(child: CircularProgressIndicator());
                }

                return Container(
                  child: Column(
                    children: items.map((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return VideoScreen(id: item.videoId);
                                },
                              ),
                            );
                          },
                          title: Text(
                            item.title,
                            style: TextStyle(color: Colors.white),
                            softWrap: true,
                          ),
                          leading: Container(
                            height: 159,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    item.defaultThumbnail.url,
                                  ),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
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
