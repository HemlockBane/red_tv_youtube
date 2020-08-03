import 'package:flutter/material.dart';
import 'package:red_tv_youtube/src/screens/welcome.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation colorAnimation;
  Animation sizeAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    colorAnimation = ColorTween(begin: Colors.grey[500], end: Colors.red[800])
        .animate(controller);
    sizeAnimation = Tween<double>(begin: 70.0, end: 100.0).animate(controller);

    // Rebuilding the screen when animation goes ahead
    controller.addListener(() {
      setState(() {});
    });

    // Repeat the animation after finish
    controller.repeat();

    //For single time
    //controller.forward()

    //Reverses the animation instead of starting it again and repeats
    //controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F3F3F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            child: Image.asset('assets/images/red_tv.jpg'),
          ),
          SizedBox(height: 15),
          Center(
            child: MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
              color: colorAnimation.value,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return WelcomeScreen(
                      title: 'Red TV Youtube',
                    );
                  }),
                );
              },
              child: Text(
                'Login'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
