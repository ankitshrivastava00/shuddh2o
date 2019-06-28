import 'package:flutter/material.dart';

class FirstFragment extends StatelessWidget {
  final logo = Container(
    width: 160.0,
    height: 160.0,
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('images/hydroberry.png'),
      ),
    ),
  );
   final logo1 = Container(
    width: 170.0,
    height: 170.0,
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('images/shudh.png'),
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
       /*appBar: AppBar(
        title: Text('ShuddhH2O'),
        backgroundColor: Colors.lightBlue,
      ),*/
      body:
      new Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bottom.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
          new Center(child: Center(
    child: ListView(
    shrinkWrap: true,
    children: <Widget>[
    logo,
    SizedBox(height: 20.0),
    logo1,

    ],
    ),
    ),
    ),
      ],
      ),
    );
  }

}