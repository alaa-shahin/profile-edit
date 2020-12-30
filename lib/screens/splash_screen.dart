import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../main.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Center(
            child: SplashScreen(
              useLoader: false,
              imageBackground: AssetImage(
                'assets/images/loading.jpeg',
              ),
              // photoSize: 30,
              seconds: 2,
              // loadingText: Text('Loading...'),
              // loaderColor: Colors.yellow,
              navigateAfterSeconds: MyApp(),
            ),
          ),
        ),
      ),
    );
  }
}
