import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  static const routeName = '/AuthForm';
  final void Function(
    String email,
    String password,
    String userName,
    String age,
    String profileImage,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool _isLoading;

  AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final fromKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _userName = '';
  String _age = '';
  String _profileImage = '';

  Future<void> submit() async {
    final isValid = fromKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      fromKey.currentState.save();
      widget.submitFn(_email.trim(), _password.trim(), _userName.trim(), _age,
          _profileImage, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Form(
              key: fromKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('userName'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 3) {
                          return 'Please enter a least 3 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'User name'),
                      onSaved: (val) => _userName = val,
                    ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('Age'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 2) {
                          return 'Please enter your Age at least 2 numbers';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Age'),
                      onSaved: (val) => _age = val,
                    ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('email'),
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (val) => _email = val,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'Please enter a least 7 characters';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('Profile Image Link'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter URL correct image';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.url,
                      decoration:
                          InputDecoration(labelText: 'Profile Image Link'),
                      onSaved: (val) => _profileImage = val,
                    ),
                  SizedBox(height: 20),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: submit,
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
