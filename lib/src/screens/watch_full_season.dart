import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchFullSeasonScreen extends StatefulWidget {
  final Playlist playlist;

  WatchFullSeasonScreen({this.playlist});
  @override
  _WatchFullSeasonScreenState createState() => _WatchFullSeasonScreenState();
}

class _WatchFullSeasonScreenState extends State<WatchFullSeasonScreen> {
  YoutubePlayerController _controller;

  int selectedVideo = 1;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.playlist.filteredItems[0].videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.title),
        backgroundColor: Color(0xff3F3F3F),
      ),
      backgroundColor: Color(0xff3F3F3F),
      body: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                widget.playlist.title,
                style: _textStyle(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                '$selectedVideo/${widget.playlist.filteredItems.length} Episodes',
                style: _textStyle(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.playlist.filteredItems.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = widget.playlist.filteredItems[index];

                  return Container(
                    // color: Colors.amber,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          setState(() {
                            selectedVideo = index + 1;
                          });
                          _controller.load(item.videoId);
                        });
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
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle(
      {Color color,
      double fontSize = 15,
      FontWeight fontWeight = FontWeight.normal}) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight);
  }
}
