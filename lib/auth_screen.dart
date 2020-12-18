import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String userName,
    String age,
    String profileImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userResult.user.uid)
            .set({
          'userName': userName,
          'email': email,
          'age': age,
          'profileImage': profileImage,
        }).catchError((error) => Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Something went wrong, please try again later'),
                  backgroundColor: Theme.of(context).errorColor,
                )));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Error Occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user';
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('app crashed'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
