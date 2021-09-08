import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                  child: Image.network(kLogo),
                  width: 80.0,
                  height: 80.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text(
                  'Flash Chat',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 55.0,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          SizedBox(height: 300.0),
          RoundedButton(
            colour: Colors.blue,
            buttonText: 'Log In',
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
          RoundedButton(
            colour: Colors.indigo,
            buttonText: 'Register',
            onPressed: () {
              Navigator.pushNamed(context, RegisterScreen.id);
            },
          ),
          SizedBox(
            height: 25.0,
          )
        ],
      ),
    );
  }
}
