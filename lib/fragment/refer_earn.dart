import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ReferEarn extends StatelessWidget {
  final logo = Container(
    width: 160.0,
    height: 160.0,
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('images/referimage.png'),
      ),
    ),
  );
   final logo1 = Container(
   child: new Center(child: new  Text("Referral Bonus : 0 Points"),
   ),);

  Future<void> shareData(){
    Share.share('Testing Sample');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,

      body:
      new Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
    child: ListView(
    children: <Widget>[
    logo,
    SizedBox(height: 20.0),
    logo1,
    SizedBox(height: 20.0),

    new Container(
        child: new SizedBox(

          width: double.infinity,

          child: new RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: shareData,
            textColor: Colors.white,
            child: new Text("SHARE"),
            color: Colors.blue,
            padding: new EdgeInsets.all(20.0),
          ),
        ),
        margin: new EdgeInsets.all(15.0)
    ),
    ],
    ),
    ),
    ),

    );
  }

}