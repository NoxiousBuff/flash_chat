import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/text_field.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  child: Image.network(kLogo),
                  width: 250.0,
                  height: 250.0,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                child: Text(
                  'Flash Chat',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w900,
                      fontSize: 50.0),
                ),
              ),
            ),
            SizedBox(height: 70.0),
            TextFieldBar(
              fieldText: '@username',
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
            ),
            TextFieldBar(
              fieldText: '@password',
              onChanged: (value) {
                password = value;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            SizedBox(height: 40.0),
            RoundedButton(
              colour: Colors.indigo,
              buttonText: 'Register',
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) {
                      return ChatScreen();
                    }));
                  }
                  setState(() {
                    showSpinner = false;
                  });
                  print(newUser);
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
