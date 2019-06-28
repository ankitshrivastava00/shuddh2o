import 'package:flutter/material.dart';
import 'package:shuddh2o/activity/forgot.dart';
import 'dart:convert';

import 'package:shuddh2o/activity/login.dart';
import 'package:shuddh2o/activity/register.dart';
import 'package:shuddh2o/drawer/home_pages.dart';

class StartScreen extends StatefulWidget{
  @override
  _StartScreenState createState() => _StartScreenState();
}
class _StartScreenState extends State<StartScreen>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
     /* appBar: AppBar(
        title: Text('ShuddhH2O'),
        backgroundColor: Colors.lightBlue,
      ),*/
      body:
      new Stack(
        children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/login_back.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
new Container(
  margin: EdgeInsets.only(bottom: 50.0),
  child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //your elements here
            new Container(

              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child:new SizedBox(
                width: double.infinity,
                child:new  RaisedButton(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pushNamed(Login());
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Login()));
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.white,
                  child: Text('Sign In', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            new Container(

              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child:
              new SizedBox(
                width: double.infinity, child:

              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  // Navigator.of(context).pushNamed(Login());
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Registration()));
                },
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: Text('Sign Up', style: TextStyle(color: Colors.black)),
              ),
              ),
            ),
            new Container(

              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child:

              new SizedBox(
                width: double.infinity,
                child: new FlatButton(

                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Forgot()));},
                ),
              ),

            ),
          ],
        )
  ,),
     ],
    ),
    );
  }
}