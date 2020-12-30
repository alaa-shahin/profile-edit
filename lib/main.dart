import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app/screens/splash_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SplashScreens());
}

class MyApp extends StatefulWidget {
  static const routeName = '/';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        AuthScreen.routeName: (ctx) => AuthScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ProfileScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
