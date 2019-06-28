import 'package:flutter/material.dart';
import 'package:shuddh2o/activity/view_single_item.dart';

class HomeFragment extends StatelessWidget {
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
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/bottom.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          new Container(
//            margin: EdgeInsets.only(bottom: 50.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //your elements here
                new Center(
                  child: new
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => ViewSingle()));
                  },
                  child: new Container(
                    width: 170.0,
                    height: 170.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('images/hydroberry.png'),
                      ),
                    ),
                  ),
                ),
                ),
                SizedBox(height: 20.0),
    new Center(
    child: new
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => ViewSingle()));
                  },
                  child: new Container(
                    width: 170.0,
                    height: 170.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('images/shudh.png'),
                      ),
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
