import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 55,
              ),

              /// ..Add your code here
              _buildWelcomeTo(),
              _buildPaddingTextBtn(),
              _buildSeries(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Container(
                            // color: Colors.grey,
                            height: 374,
                            width: 239,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/the_menn.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'THE MEN\'S CLUB',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'SEASON 3',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                                image:
                                    AssetImage('assets/images/asst_madam.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'ASSISTANT MADAM',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'SEASON 3',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
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
              ),
              _buildPopularNowSection(),
              _buildExclusivesSection()
            ],
          ),
        ),
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
    return _buildMiniCarousel(title: 'Popular Now');
  }

  Widget _buildExclusivesSection() {
    return _buildMiniCarousel(title: 'Exclusives');
  }

  Widget _buildMiniCarousel({@required String title}) {
    final imageUrl =
        'https://cdn.pixabay.com/photo/2015/09/09/16/05/forest-931706_960_720.jpg';

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
                  onTap: () {},
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
          ),
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
