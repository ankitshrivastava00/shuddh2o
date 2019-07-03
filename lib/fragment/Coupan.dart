import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/Cart.dart';
import 'package:shuddh2o/common/Constants.dart';
import 'package:shuddh2o/model/CoupanModel.dart';

class CoupanList extends StatefulWidget {


  @override
  CoupanListState createState() => CoupanListState();
}

class CoupanListState extends State<CoupanList> {
  String reply = "", status = "";
  List<CoupanModel> lis = List();
  int price = 0;
  double carttotal = 0.0,peramt = 0.0;
  DBProvider db ;
  var isLoading = false ;

  @override
  Future initState() {
    super.initState();
    fetcwish();
    cal();
  }

  Future cal() async {
    var total = (await DBProvider.db.calculateTotal())[0]['Total'];
    setState(() {
      if(total != null){
        setState(() => carttotal = total);
      }
    });
    }

  Future fetcwish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    coupanlist(Constants.Coupan_URL);
  }

  Future<String> coupanlist(String url) async {
    try {
      setState(() {
        isLoading= true;
      });
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['status'].toString();

      if (status == "300") {
        Fluttertoast.showToast(
            msg: "No any Offer",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        for (var word in data['result']) {
          String id = word["_id"].toString();
          String coupan_name = word["promoname"].toString();
          String coupon_code = word["promocode"].toString();
          String discount_type = word["discounttype"].toString();
          String discount_amount = word["discount"].toString();
          String start_date = word["startdate"].toString();
          String end_date = word["end_date"].toString();
          setState(() {
            lis.add(CoupanModel(id, coupan_name, coupon_code, discount_type, discount_amount,
                start_date, end_date));
          });
        }
      }

//var array = data['data'];
      print('RESPONCE_DATA : ' + status);
      setState(() {
        isLoading= false;
      });
    }
    /*else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: "Please check your internet connection....!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // ToastWrap.showToast("Please check your internet connection....!");
        // return response;
      }
    }*/
    catch (e) {
      setState(() {
        isLoading= false;
      });
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightBlue,
          title: new Text("Coupan"),
        ),
        body: new Container(
          child:isLoading ? Center(
              child: new Container(
                child:
                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.blue),
                  strokeWidth: 5.0,
                  semanticsLabel: 'is Loading',),
              )
          ):
          ListView.builder(
              itemCount: lis.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      child: Card(
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                child: Image(image: AssetImage('images/offerr.jpg')),
                                width: 100.0,
                                height: 100.0,
                              ),
                              new Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                        EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text("Code - "+
                                          lis[index].code,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                        EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].type,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      new Container(
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10.0, 2.0, 0.0, 0.0),
                                              alignment: Alignment.topLeft,
                                              child: new Text("Rs. "+
                                                lis[index].amount,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    if(lis[index].type == "flat" && carttotal>double.parse(lis[index].amount)){
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                              new Cart(lis[index].id,lis[index].name,lis[index].code,lis[index].type,lis[index].amount)
                          )
                      );
                    }else if(lis[index].type == "percent"){
                      peramt = (carttotal*double.parse(lis[index].amount))/100.0 ;
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                              new Cart(lis[index].id,lis[index].name,lis[index].code,lis[index].type,peramt.toString())
                          )
                      );
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Sorry you cant apply this coupan",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                  },
                );
              }),
        )
    );
  }
}
