import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';


class ViewSingle extends StatefulWidget {
 // MyHomePage({Key key, this.title}) : super(key: key);

 // final String title;

  @override
  _ViewSingleState createState() => new _ViewSingleState();
}

class _ViewSingleState extends State<ViewSingle> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('View Item'),
      ),
      body:       new Stack(
        children: <Widget>[
       new Container(
            width: double.infinity,
            height: 250.0,
           // margin: EdgeInsets.only(bottom: 50.0),
            child:/* new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[*/
                //your elements here
             new Swiper(
                      itemBuilder: (BuildContext context,int index){
                        return /*new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);*/
                        new Container(
                        width: 160.0,
                        height: 160.0,
                        decoration: new BoxDecoration(
                        image: new DecorationImage(
                        image: new AssetImage('images/productimage.png'),
                        ),
                        ),
                        );

                      },
                      itemCount: 2,
                      pagination: new SwiperPagination(),
                      control: new SwiperControl(),

                ),

           ),

        ],
      ),
    );
  }
}
