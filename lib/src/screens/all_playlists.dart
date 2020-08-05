import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/notifiers/red_tv.dart';
import 'package:red_tv_youtube/src/screens/video_screen.dart';

class AllPlaylistsScreen extends StatefulWidget {
  @override
  _AllPlaylistsScreenState createState() => _AllPlaylistsScreenState();
}

class _AllPlaylistsScreenState extends State<AllPlaylistsScreen> {
  bool isLoading = false;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final redTV = RedTVChannelNotifier.of(context);
      final playlists = redTV.playlists;

      _scrollController = ScrollController();
      _scrollController.addListener(() {
        //     'playlist_items: is less than 20 elements - ${playlistItems.length < 20}');

        if (!isLoading &&
            _scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            playlists.length <= redTV.totalplaylistCount) {
          print('all_playlists: scroll listener should load');
          // fetchMorePopularNowItems().then((_) {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F3F3F),
      appBar: AppBar(
        title: Text('All Playlists'),
        backgroundColor: Color(0xFF3F3F3F),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: isLoading ? CircularProgressIndicator() : Container(),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Consumer<RedTVChannelNotifier>(
                      builder: (context, redTV, _) {
                        final playlists = redTV.playlists;
                        return Container(
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: playlists.length,
                            itemBuilder: (context, index) {
                              final playlist = playlists[index];

                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  onTap: () {},
                                  title: Text(
                                    playlist.title,
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
                                            playlist.defaultThumbnail.url,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        )),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
