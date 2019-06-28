import 'package:flutter/material.dart';
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/Details.dart';
import 'package:shuddh2o/model/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllCategoriesFragment extends StatefulWidget {
  @override
  _AllCategoriesFragmentState createState() =>
      new _AllCategoriesFragmentState();
}

class _AllCategoriesFragmentState extends State<AllCategoriesFragment> {
  List<OrderModel> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get("https://sheltered-woodland-33544.herokuapp.com/viewproduct");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new OrderModel.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchData();
    super.initState();
  }

  Widget GridGenerate(List<OrderModel> data, aspectRadtio) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: aspectRadtio),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                /* onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> Details(detail: data[index]))
                  );
                },*/
                child: Container(
                    height: 350.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 8.0)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child:
                                  /*Container(
                                    child: Image.network(data[index].image,fit: BoxFit.contain,),
                                  ),*/
                                  new Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: new AssetImage(
                                            'images/productimage.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                /*  Container(
                                  child: data[index].fav ? Icon(Icons.favorite,size: 20.0,color: Colors.red,) : Icon(Icons.favorite_border,size: 20.0,),
                                )*/
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${data[index].Title}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.0,color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "Price : Rs. ${double.tryParse(data[index].price.toString())}",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black54
                                  ),
                                ),
                              )
                            ],
                          ),

                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Litre : ${data[index].category.toString()}",
                            style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black54),
                          ),
                        ) , Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Discount : ${data[index].discount.toString()} %",
                            style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black54),
                          ),
                        ) ,
                        Container(
                          alignment: Alignment(0.0, 0.0),
                          child:
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onPressed: (){
                                /* print('${data[index].Id}');
                    double p = double.tryParse('${data[index].price}');
                    DBProvider.db.newClient('${data[index].Id.toString()}','${data[index].Title.toString()}','1','${p}','${data[index].category.toString()}');
               */
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=> Details(detail: data[index])));
                              },
                              /*onPressed: () {
          // Navigator.of(context).pushNamed(Login());
          _handleSignIn();
        },*/
                              color: Colors.deepOrange,
                              child: Text('View', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    )),
              ));
        },
        itemCount: data.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.0;
    final double itemWidth = size.width / 2;
    return Scaffold(
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :
        /*ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                          Container(
//            margin: EdgeInsets.only(bottom: 50.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //your elements here
                           */ /* new Center(
                              child: new GestureDetector(
                                onTap: () {
                                 */ /**/ /* Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ViewSingle()));*/ /**/ /*
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
                            ),*/ /*
                        new Container(
                        width: 160.0,
                          height: 160.0,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage('images/productimage.png'),
                            ),
                          ),
                        ),
                            SizedBox(height: 20.0),

                            new Center(
                              child: new GestureDetector(
                                onTap: () {
                                  */ /* Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ViewSingle()));*/ /*
                                },
                                child: new Container(
                                  child: new Text(list[index].discount,
                                  style:
                                    TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0
                                    ),)
                                  ,
                                 */ /* width: 170.0,
                                  height: 170.0,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage('images/shudh.png'),
                                    ),
                                  ),*/ /*
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),*/
        /* ScopedModelDescendant<OrderModel>(builder: (context, child, model) {
              return */GridGenerate(list, (itemWidth / itemHeight))
      // }),
    );
  }
}
