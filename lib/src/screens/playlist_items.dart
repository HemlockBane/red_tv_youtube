import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/notifiers/exclusives_playlist.dart';
import 'package:red_tv_youtube/src/screens/video_screen.dart';

class PlaylistItemsScreen extends StatefulWidget {
  @override
  _PlaylistItemsScreenState createState() => _PlaylistItemsScreenState();
}

class _PlaylistItemsScreenState extends State<PlaylistItemsScreen> {
  bool isLoading = false;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final exclusives = ExclusivesPlaylistNotifier.of(context);
      final playlist = exclusives.playlist;
      final playlistItems = exclusives.playlist.items;

      _scrollController = ScrollController();
      _scrollController.addListener(() {
        //     'playlist_items: is less than 20 elements - ${playlistItems.length < 20}');

        if (!isLoading &&
            _scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            playlistItems.length <= playlist.itemCount) {
          print('playlist_items: scroll listener should load');
          fetchMorePlaylistItems().then((_) {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F3F3F),
      appBar: AppBar(
        title: Text('Exclusives'),
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
                    child: Consumer<ExclusivesPlaylistNotifier>(
                      builder: (context, exclusives, _) {
                        final playlistItems = exclusives.playlist.items;
                        return Container(
                          // color: Colors.amber,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: playlistItems.length,
                            itemBuilder: (context, index) {
                              final playlistItem = playlistItems[index];

                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return VideoScreen(
                                          id: playlistItem.videoId,
                                        );
                                      }),
                                    );
                                  },
                                  title: Text(
                                    playlistItem.title,
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
                                            playlistItem.maxresThumbnail.url,
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

  Future fetchMorePlaylistItems() async {
    setState(() {
      isLoading = true;
    });
    await ExclusivesPlaylistNotifier.of(context).getPlaylistItems();
    setState(() {
      isLoading = false;
    });
  }
}
