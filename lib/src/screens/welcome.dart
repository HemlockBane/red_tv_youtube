import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/models/channel_model.dart';
import 'package:red_tv_youtube/src/screens/playlist_details.dart';
import 'package:red_tv_youtube/src/screens/series_details.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

final imageUrl =
    'https://cdn.pixabay.com/photo/2015/09/09/16/05/forest-931706_960_720.jpg';

final imageSeries = 'assets/images/the_menn.jpg';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Channel _channel;
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCmaJwjJJkzMttK8L79g_8zA');
    setState(() {
      _channel = channel;
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

              /// ..Add your code here
              _buildWelcomeTo(),
              _buildPaddingTextBtn(),
              _buildSeries(),
              _buildSeriesCarousel(),
              _buildPopularNowSection(),
              _buildExclusivesSection()
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSeriesCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return SeriesDetailsScreen();
                      }),
                    );
                  },
                  child: Container(
                    // color: Colors.grey,
                    height: 374,
                    width: 239,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageSeries),
                        fit: BoxFit.fitHeight,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
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
                ),
                SizedBox(width: 15),
                Container(
                  // color: Colors.grey,
                  height: 374,
                  width: 239,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/asst_madam.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'ASSISTANT MADAM'.toUpperCase(),
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
                          'SEASON 1'.toUpperCase(),
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
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Column _buildSeries() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildPaddingTextBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              "REDTV is a fast paced  lifestyle channel that puts Africa on the global stage. \n\n Proudly associated with the United Bank for Africa, REDTV is here to entertain and inform with content that features the very best in entertainment, fashion, news, design, music, sport, movies and travel. \n \n REDTV collaborates with the most talented visionaries, creative minds daring to believe in a New Africa, putting together content that reflects it. Feel the Heat on REDTV.",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity / 2,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                color: Color(0xFFCACACA),
                child: Text(
                  'Read More',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity / 2,
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                color: Colors.red[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  'Subscribe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildWelcomeTo() {
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

  Widget _buildPopularNowSection() {
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

  Widget _buildExclusivesSection() {
    return _buildMiniCarousel(title: 'Exclusives');
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
              itemCount: imageUrls.length, // 1 + _channel.videos.length
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
                      color: Colors.blue,
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
