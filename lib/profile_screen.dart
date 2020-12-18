import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String _newUserName;
  String _newAge;
  final _formKey = GlobalKey<FormState>();
  var docRef;

  fetch() async {
    return await FirebaseFirestore.instance
        .collection('users')
        // .doc(currentUser.uid)
        // .get();
        .where('email', isEqualTo: currentUser.email)
        .get()
        .then((querySnapshot) {
      docRef = querySnapshot.docs[0];
      return querySnapshot.docs[0].data();
    }).catchError((onError) {
      print("Error getting documents: $onError");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong while fetching your data'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  title: Text('Your Profile'),
                  actions: <Widget>[
                    DropdownButton(
                      underline: Container(),
                      icon: Icon(Icons.more_vert,
                          color: Theme.of(context).primaryIconTheme.color),
                      items: [
                        DropdownMenuItem(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                          value: 'logout',
                        ),
                      ],
                      onChanged: (item) {
                        if (item == 'logout') {
                          FirebaseAuth.instance.signOut();
                        }
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data['profileImage']),
                              maxRadius: 50,
                              backgroundColor: Colors.lightGreen[500],
                            ),
                            Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('User name:'),
                              decoration:
                                  InputDecoration(labelText: 'User name'),
                              keyboardType: TextInputType.text,
                              initialValue: data['userName'],
                              onChanged: (val) => _newUserName = val,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('Email:'),
                              decoration: InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.text,
                              initialValue: data['email'],
                              readOnly: true,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('Age:'),
                              decoration: InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType.number,
                              initialValue: data['age'],
                              onChanged: (val) {
                                _newAge = val;
                              },
                            ),
                            SizedBox(height: 30),
                            Container(
                              height: 60.0,
                              width: 300.0,
                              padding: const EdgeInsets.all(10.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUser.uid)
                                        .set({
                                      'userName': (_newUserName == null)
                                          ? data['userName']
                                          : _newUserName,
                                      'age': (_newAge == null)
                                          ? data['age']
                                          : _newAge,
                                      'email': currentUser.email,
                                      'profileImage': data['profileImage'],
                                    }).catchError((error) =>
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Something went wrong, please try again later'),
                                              backgroundColor:
                                                  Theme.of(context).errorColor,
                                            )));
                                    //  show notification
                                    Flushbar(
                                      title: "Yaaay",
                                      message: "Successfully Saved!",
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Please enter valid data!'),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ));
                                  }
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.white,
            );
          }
        });
  }
}
