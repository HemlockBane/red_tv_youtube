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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Color(0xFFCACACA),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildPopularNowSection(),
              _buildExclusivesSection()
            ],
          ),
        ),
      ),
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
