import 'package:SampleApp/Screens/Home.dart';

import '../Extensions/Color_Extension.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: iniScreen(context),
    );
  }

   startTime() async {
     var duration = new Duration(seconds: 5);
     return new Timer(duration, route);
   }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Home()
        )
    );
  }

   iniScreen(BuildContext context) {
    AssetImage assetImage = AssetImage("images/todo_logo.png");
    Image image = Image (
      image: assetImage,
      width: 200,
      height: 200,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: '2A5470'.toColor(),
            gradient: LinearGradient(colors: ['2A5470'.toColor(),'4C4177'.toColor()],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
            )
          ),
        ),
         Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
               child: image,
             ),
             Padding(padding: EdgeInsets.only(bottom: 20)),
           ],
         )
      ],
    );

  }
}