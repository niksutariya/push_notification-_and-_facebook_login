import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginUser extends StatefulWidget {
  const FacebookLoginUser({Key? key}) : super(key: key);

  @override
  _FacebookLoginUserState createState() => _FacebookLoginUserState();
}

class _FacebookLoginUserState extends State<FacebookLoginUser> {
  bool _isLogIn = false;
  Map _userData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Login'),
      ),
      body: Container(
        child: _isLogIn
            ? Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          "https://play-lh.googleusercontent.com/5pZMqQYClc5McEjaISPkvhF8pDmlbLqraTMwk1eeqTlnUSjVxPCq-MItIrJPJGe7xW4"),
                    ),
                    const SizedBox(height: 30),
                    Text(_userData['name']),
                    Text(_userData['email']),
                    TextButton(
                      onPressed: () {
                        FacebookAuth.instance.logOut().then((value) {
                          setState(() {
                            _isLogIn = false;
                            _userData = {};
                          });
                        });
                      },
                      child: const Text('Logout'),
                    )
                  ],
                ),
              )
            : Center(
                child: ElevatedButton(
                    child: const Text('Login with Facebook'),
                    onPressed: () async {
                      FacebookAuth.instance
                          .login(permissions: ['email', 'public_profile']).then(
                              (value) {
                        FacebookAuth.instance.getUserData().then((userData) {
                          log('userData :  $userData');
                          setState(() {
                            _isLogIn = true;
                            _userData = userData;
                          });
                        });
                      });
                    }),
              ),
      ),
    );
  }
}
