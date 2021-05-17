import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Pages/Home.dart';

class Intro extends StatefulWidget
{
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro>
{
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }

  Widget _introScreen()
  {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 2,
          navigateAfterSeconds: Home(),
          loaderColor: Color(0xffB03060),
        ),
        Center(
          child: Image.asset("assets/ic_logo.png", height: 200, width: 200),
        )
      ],
    );
  }
}
