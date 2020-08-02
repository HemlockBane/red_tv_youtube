import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/screens/playlist_details.dart';
import 'package:red_tv_youtube/src/screens/series_details.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

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
  bool isLoading = false;

  APIService _apiService = APIService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      _isSubscribed = await _apiService.checkIfUserIsSubscribed();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 55,
                    ),
                    _buildWelcomeBanner(),
                    _buildInfoAndButtons(),
                    _buildSeriesCarousel(),
                    _buildPopularNowCarousel(),
                    _buildExclusivesCarousel()
                  ],
                ),
              ),
            ),
    );
  }

  Row _buildWelcomeBanner() {
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

  Padding _buildInfoAndButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              "REDTV is a fast paced  lifestyle channel that puts Africa on the global stage. "
              "\n\nProudly associated with the United Bank for Africa, REDTV is here "
              "to entertain and inform with content that features the very "
              "best in entertainment, fashion, news, design, music, sport, "
              "movies and travel.\n\nREDTV collaborates with the "
              "most talented visionaries, creative minds daring to believe in a New Africa, putting "
              "together content that reflects it. Feel the Heat on REDTV.",
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
            Container(
              width: double.infinity / 2,
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                color: Colors.red[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                child: Text(
                  _isSubscribed ? 'Subscribed' : 'Subscribe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  // if (!_isSubscribed) {
                  //   setState(() {
                  //     isLoading = true;
                  //   });
                  //   await _apiService.subscribe();
                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildSeriesCarousel() {
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
                Text(
                  'New Episodes',
                  style: TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return SeriesDetailsScreen();
                            }),
                          );
                        },
                        child: Container(
                          height: 274,
                          width: 179,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imageSeries),
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
                                  'THE MEN\'S CLUB'.toUpperCase(),
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
                                Text(
                                  'SEASON 3'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
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
                      // return Row(
                      //   children: <Widget>[
                      //     // Container(
                      //     //   height: 374,
                      //     //   width: 239,
                      //     //   decoration: BoxDecoration(
                      //     //     image: DecorationImage(
                      //     //       image: AssetImage('assets/images/asst_madam.jpg'),
                      //     //       fit: BoxFit.fitHeight,
                      //     //     ),
                      //     //     shape: BoxShape.rectangle,
                      //     //     borderRadius: BorderRadius.circular(10),
                      //     //   ),
                      //     //   child: Padding(
                      //     //     padding: const EdgeInsets.symmetric(
                      //     //         horizontal: 15.0, vertical: 15.0),
                      //     //     child: Column(
                      //     //       mainAxisAlignment: MainAxisAlignment.end,
                      //     //       crossAxisAlignment: CrossAxisAlignment.start,
                      //     //       children: <Widget>[
                      //     //         Text(
                      //     //           'ASSISTANT MADAM'.toUpperCase(),
                      //     //           style: TextStyle(
                      //     //             fontWeight: FontWeight.bold,
                      //     //             fontSize: 18,
                      //     //             color: Colors.white,
                      //     //             shadows: [
                      //     //               Shadow(
                      //     //                 blurRadius: 12.0,
                      //     //                 color: Colors.black,
                      //     //                 offset: Offset(1.0, 5.0),
                      //     //               ),
                      //     //             ],
                      //     //           ),
                      //     //         ),
                      //     //         Text(
                      //     //           'SEASON 1'.toUpperCase(),
                      //     //           style: TextStyle(
                      //     //             fontWeight: FontWeight.w400,
                      //     //             fontSize: 18,
                      //     //             color: Colors.white,
                      //     //             shadows: [
                      //     //               Shadow(
                      //     //                 blurRadius: 12.0,
                      //     //                 color: Colors.black,
                      //     //                 offset: Offset(1.0, 5.0),
                      //     //               ),
                      //     //             ],
                      //     //           ),
                      //     //         ),
                      //     //       ],
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //   ],
                      // );
                    },
                  ),
                ),
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

  Widget _buildPopularNowCarousel() {
    return _buildMiniCarousel(
        title: 'Popular Now',
        onItemTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return PlaylistDetailsScreen();
            }),
          );
        });
  }

  Widget _buildExclusivesCarousel() {
    return _buildMiniCarousel(
        title: 'Exclusives',
        onItemTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return PlaylistDetailsScreen();
            }),
          );
        });
  }

  Widget _buildMiniCarousel({@required String title, VoidCallback onItemTap}) {
    final imageUrls = List.generate(10, (_) => imageUrl);

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
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
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
