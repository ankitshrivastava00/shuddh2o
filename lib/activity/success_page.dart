import 'package:flutter/material.dart';
//import 'package:share/share.dart';
import 'package:shuddh2o/drawer/home_pages.dart';

class SuccessPage extends StatelessWidget {
  final logo = Container(
    width: 120.0,
    height: 120.0,
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('images/correct.png'),
      ),
    ),
  );
   final logo1 = Container(
   child: new Center(child: new  Text("Hurry!"),
   ),);
  final logo2 = Container(
   child: new Center(child: new  Text("We've received your  order."),
   ),);





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Future<void> shareData(){
      // Share.share('Testing Sample');
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => HomePage(1)));
    }
    Future<bool> _onWillPop() {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => HomePage(0)));

    }
    return  new WillPopScope(
        onWillPop: _onWillPop,
        child:
        Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.blue  ,
      ),
      backgroundColor: Colors.white,

      body:
      new Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
    child: ListView(
      shrinkWrap: true,

      children: <Widget>[
    logo,
    SizedBox(height: 20.0),
    logo1,
    SizedBox(height: 5.0),
    logo2,
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
            child: new Text("MY ORDER"),
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
    ),

    );
  }

}