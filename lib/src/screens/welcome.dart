import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/channel.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:red_tv_youtube/src/models/popular_now_item.dart';
import 'package:red_tv_youtube/src/notifiers/exclusives_playlist.dart';
import 'package:red_tv_youtube/src/notifiers/popular_now.dart';
import 'package:red_tv_youtube/src/notifiers/red_tv.dart';
import 'package:red_tv_youtube/src/screens/all_playlists.dart';
import 'package:red_tv_youtube/src/screens/exclusive_items_screen.dart';
import 'package:red_tv_youtube/src/screens/popular_now_items.dart';
import 'package:red_tv_youtube/src/screens/series_details.dart';
import 'package:red_tv_youtube/src/screens/video_screen.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

final imageUrl = 'https://i.ytimg.com/vi/iNJt2WLH1EY/sddefault.jpg';

final imageSeries = 'assets/images/the_menn.jpg';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _shouldShowMore = false;
  bool _isSubscribed = false;
  bool isLoadingSubscription = true;
  bool isLoadingRedTV = true;

  bool isLoadingExclusives = true;
  bool isLoadingPopularNow = true;

  String token = '';

  APIService _apiService = APIService.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/youtube'
  ]);
  GoogleSignInAccount _gAccount;

  @override
  void initState() {
    super.initState();
    _initSubscriptions();
    _initChannel();
    _initExclusives();
    _initPopularNow();
  }

  void _initChannel() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final redTV = RedTVChannelNotifier.of(context);
      await redTV.getChannelDetails();
      print(redTV.playlists);
      setState(() {
        isLoadingRedTV = false;
      });
    });
  }

  /// Gets a Google 0Auth 2.0 token for the user's Youtube account and signs the
  /// user checks if the user is subscribed to the RedTV channel
  void _initSubscriptions() {
    if (_googleSignIn.currentUser == null) {
      _googleSignIn.signIn().then((gAccount) async {
        _gAccount = gAccount;
        // print('current user: $_gAccount');
        var auth = await _gAccount.authentication;
        token = auth.accessToken;
        // print('access token - $token');
        _isSubscribed =
            await _apiService.checkIfUserIsSubscribed(authToken: token);

        setState(() {
          isLoadingSubscription = false;
        });
      }).catchError((e) {
        print('welcome.dart: $e');
      });
    } else {
      _googleSignIn.currentUser.authentication.then((gAccount) async {
        // print('current user: $gAccount');
        var auth = await _gAccount.authentication;
        token = auth.accessToken;
        // print('access token - $token');
        _isSubscribed =
            await _apiService.checkIfUserIsSubscribed(authToken: token);

        setState(() {
          isLoadingSubscription = false;
        });
      });
    }
  }

  void _initExclusives() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final exclusives = ExclusivesPlaylistNotifier.of(context);
      await exclusives.getPlaylist();

      setState(() {
        isLoadingExclusives = false;
      });
    });
  }

  void _initPopularNow() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final popularNow = PopularNowNotifier.of(context);
      await popularNow.getPopularNowVideos();
      setState(() {
        isLoadingPopularNow = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 55,
              ),
              _buildWelcomeBanner(),
              Consumer<RedTVChannelNotifier>(
                builder: (context, redTV, _) {
                  if (isLoadingRedTV) {
                    return _showShimmerPlaceholder();
                  }

                  return _buildInfoAndButtons(
                    redTVChannel: redTV.channel,
                  );
                },
              ),
              Consumer<RedTVChannelNotifier>(
                builder: (context, redTV, _) {
                  return _buildSeriesCarousel(
                    playlists: redTV.playlists.take(5).toList(),
                  );
                },
              ),
              Consumer<PopularNowNotifier>(
                builder: (context, popularNow, _) {
                  return _buildPopularNowCarousel(
                      popularNowItems: popularNow.items);
                },
              ),
              Consumer<ExclusivesPlaylistNotifier>(
                builder: (context, exclusives, _) {
                  return _buildExclusivesCarousel(exclusives.playlist);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Welcome to',
          style: TextStyle(
            color: Color(0xFFCACACA),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 15),
        Container(
          width: 50,
          height: 50,
          child: Image.asset('assets/images/red_tv.jpg'),
        ),
      ],
    );
  }

  Widget _showShimmerPlaceholder({double height = 200}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Color(0xFFCACACA),
        highlightColor: Color(0xFFCACACA).withOpacity(0.33),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            // childless container needs to be visible for shimmer to show
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Padding _buildInfoAndButtons({Channel redTVChannel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              redTVChannel.description,
              maxLines: _shouldShowMore ? null : 7,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Container(),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity / 2,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                color: Color(0xFFCACACA),
                child: Text(
                  _shouldShowMore ? 'Show Less' : 'Read More',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _shouldShowMore = !_shouldShowMore;
                  });
                },
              ),
            ),
            if (!_isSubscribed)
              Container(
                width: double.infinity / 2,
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  color: Colors.red[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    'Subscribe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (!_isSubscribed) {
                      setState(() {
                        isLoadingSubscription = true;
                      });
                      _isSubscribed =
                          await _apiService.subscribe(authToken: token);
                      setState(() {
                        isLoadingSubscription = false;
                      });
                    }
                  },
                ),
              ),
            if (_isSubscribed)
              Text(
                'Subscribed',
                style: _textStyle(color: Colors.white),
              )
          ],
        ),
      ),
    );
  }

  Column _buildSeriesCarousel({List<Playlist> playlists}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Series',
                  style: TextStyle(
                    color: Color(0xFFCACACA),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                if (isLoadingRedTV) _showShimmerPlaceholder(),
                if (!isLoadingRedTV) _showSeriesCarousel(playlists),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showSeriesCarousel(List<Playlist> playlists) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          if (index == 4) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: RaisedButton(
                  color: Colors.red[700],
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return AllPlaylistsScreen();
                      },
                    ));
                  },
                  child: Text(
                    'Show All',
                    style: _textStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            );
          }

          final playlist = playlists[index];
          final imageUrl = playlist.maxresThumbnail.isValid
              ? playlist.maxresThumbnail.url
              : playlist.standardThumbnail.isValid
                  ? playlist.standardThumbnail.url
                  : playlist.defaultThumbnail.url;

          // print(imageUrl);

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return SeriesDetailsScreen(
                    series: playlist,
                  );
                }),
              );
            },
            child: Container(
              height: 274,
              width: 179,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  fit: BoxFit.fitHeight,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      playlist.title.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 12.0,
                            color: Colors.black,
                            offset: Offset(1.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularNowCarousel({List<PopularNowItem> popularNowItems}) {
    final items = popularNowItems.take(5).toList();

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Popular Now',
            style: _textStyle(color: Color(0xFFCACACA)),
          ),
          if (isLoadingPopularNow) _showShimmerPlaceholder(),
          if (!isLoadingPopularNow) _showPopularNowCarousel(items)
        ],
      ),
    );
  }

  Widget _showPopularNowCarousel(List<PopularNowItem> items) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      height: 117,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (index == 4) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: RaisedButton(
                  color: Colors.red[700],
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return PopularNowItemsScreen();
                      },
                    ));
                  },
                  child: Text(
                    'Show All',
                    style: _textStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            );
          }

          final item = items[index];
          final imageUrl = item.mediumThumbnail.url;
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return VideoScreen(
                    id: item.videoId,
                  );
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 98,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExclusivesCarousel(Playlist exclusivesPlaylist) {
    final playlistItems = exclusivesPlaylist.filteredItems.take(5).toList();

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Exclusives',
            style: _textStyle(color: Color(0xFFCACACA)),
          ),
          if (isLoadingExclusives) _showShimmerPlaceholder(),
          if (!isLoadingExclusives) _showExclusivesCarousel(playlistItems)
        ],
      ),
    );
  }

  Widget _showExclusivesCarousel(List<PlaylistItem> playlistItems) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      height: 117,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlistItems.length,
        itemBuilder: (context, index) {
          if (index == 4) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: RaisedButton(
                  color: Colors.red[700],
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ExclusivesItemsScreen();
                      },
                    ));
                  },
                  child: Text(
                    'Show All',
                    style: _textStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            );
          }

          final playlistItem = playlistItems[index];
          final imageUrl = playlistItem.maxresThumbnail.url;
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return VideoScreen(
                    id: playlistItem.videoId,
                  );
                },
              ));
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 98,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniCarousel(
      {@required String title,
      List<String> imageUrls,
      VoidCallback onItemTap,
      VoidCallback onShowAllTap}) {
    // final imageUrls = List.generate(5, (_) => imageUrl);

    return Container(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: _textStyle(color: Color(0xFFCACACA)),
          ),
          Container(
            margin: EdgeInsets.only(top: 9),
            height: 117,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        color: Colors.red[700],
                        onPressed: () {
                          if (onItemTap != null) onShowAllTap();
                        },
                        child: Text(
                          'Show All',
                          style: _textStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  );
                }

                final imageUrl = imageUrls[index];
                return InkWell(
                  onTap: () {
                    if (onItemTap != null) onItemTap();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 98,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  TextStyle _textStyle({Color color = Colors.white, double fontSize = 16}) {
    return Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(color: color, fontSize: fontSize);
  }
}
