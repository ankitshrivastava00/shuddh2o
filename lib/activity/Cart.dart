import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
//import 'package:razorpay_plugin/razorpay_plugin.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/DBUtils/ClientModel.dart';
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/success_page.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'package:shuddh2o/common/CustomProgressDialog.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/drawer/home_pages.dart';

import 'checkout.dart';
class Cart extends StatefulWidget{
  static final String route = "Cart-route";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CartState();
  }
}

class CartState extends State<Cart>{
  double _total;
  Client item;
  List<Client> _cart = [];
  String reply;
  TextEditingController promocodeController = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
setState(() {
  _calcTotal();
  getSharedPreferences();

});
  }

  void checkoutData(String status,String paymentId,String OrderId) async{
    try {
      if (_total == 0.0) {
        Fluttertoast.showToast(msg: "Cart Is Empty", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
      } else {
    var product_name = new StringBuffer();
    var product_id = new StringBuffer();
    var price = new StringBuffer();
    var category = new StringBuffer();
    var quantity = new StringBuffer();
    var availablequantity = new StringBuffer();
    product_name.clear();
    product_id.clear();
    price.clear();
    category.clear();
    quantity.clear();
    availablequantity.clear();
    _cart =[];
    List<Map> list = await DBProvider.db.getAllClientsCard();
     list.map((dd){
        Client d = new Client();
        d.id = dd["id"];
        d.product_id = dd["product_id"];
        d.product_name = dd["product_name"];
        d.quantity = dd["quantity"];
        d.category = dd["category"];
        d.price = dd["price"];
        _cart.add(d);
      }).toList();

     for(int i=0;i<_cart.length;i++){
      if (product_name.isEmpty){
        product_name.write('${_cart[i].product_name}');
        product_id.write('${_cart[i].product_id}');
        price.write('${_cart[i].price}');
        category.write('${_cart[i].category}');
        quantity.write('${_cart[i].quantity}');
        availablequantity.write('100');

      }else{
        product_name.write(',${_cart[i].product_name}');
        product_id.write(',${_cart[i].product_id}');
        price.write(',${_cart[i].price}');
        category.write(',${_cart[i].category}');
        quantity.write(',${_cart[i].quantity}');
        availablequantity.write(',100');
      }
     }


        // registrationTask(_mobile);
        String url ="https://sheltered-woodland-33544.herokuapp.com/order";

        Map map = {
          "paymentid":'${paymentId}',
          "paymentStatus":'${status}',
          "product_name":'${product_name}',
          "userid":'${userId}',
          "discounttotal":'${_total}',
          "category":'[${category}]',
          "Quentity":'[${quantity}]',
          "price":'[${price}]',
          "total":'${_total}',
          "orderid":'${OrderId}',
          "avelabelQuentity":'[${availablequantity}]'
        };

    apiCallForUserProfile(url, map);
      }
    } catch (e) {
      print(e.toString());
    }

  }

  void checkoutData1() async{
    try {
      if (_total == 0.0) {
        Fluttertoast.showToast(msg: "Cart Is Empty", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
      } else {
    var product_name = new StringBuffer();
    var product_id = new StringBuffer();
    var price = new StringBuffer();
    var category = new StringBuffer();
    var quantity = new StringBuffer();
    var availablequantity = new StringBuffer();
    product_name.clear();
    product_id.clear();
    price.clear();
    category.clear();
    quantity.clear();
    availablequantity.clear();
    _cart =[];
    List<Map> list = await DBProvider.db.getAllClientsCard();
     list.map((dd){
        Client d = new Client();
        d.id = dd["id"];
        d.product_id = dd["product_id"];
        d.product_name = dd["product_name"];
        d.quantity = dd["quantity"];
        d.category = dd["category"];
        d.price = dd["price"];
        _cart.add(d);
      }).toList();

     for(int i=0;i<_cart.length;i++){
      if (product_name.isEmpty){
        product_name.write('${_cart[i].product_name}');
        product_id.write('${_cart[i].product_id}');
        price.write('${_cart[i].price}');
        category.write('${_cart[i].category}');
        quantity.write('${_cart[i].quantity}');
        availablequantity.write('100');

      }else{
        product_name.write(',${_cart[i].product_name}');
        product_id.write(',${_cart[i].product_id}');
        price.write(',${_cart[i].price}');
        category.write(',${_cart[i].category}');
        quantity.write(',${_cart[i].quantity}');
        availablequantity.write(',100');
      }
     }


      /*  // registrationTask(_mobile);
        String url ="https://sheltered-woodland-33544.herokuapp.com/order";

        Map map = {
          "paymentid":'${paymentId}',
          "paymentStatus":'${status}',
          "product_name":'${product_name}',
          "userid":'${userId}',
          "discounttotal":'${_total}',
          "category":'[${category}]',
          "Quentity":'[${quantity}]',
          "price":'[${price}]',
          "total":'${_total}',
          "orderid":'${OrderId}',
          "avelabelQuentity":'[${availablequantity}]'
        };*/
    Navigator.pushReplacement(context
        ,new MaterialPageRoute(builder: (BuildContext context) => CheckOutPgae('${_total}',"0.0",'${_total}','test123','${product_id}','${product_name}','${price}','${quantity}')));

    //apiCallForUserProfile(url, map);
      }
    } catch (e) {
      print(e.toString());
    }

  }
void _calcTotal() async{

  var total = (await DBProvider.db.calculateTotal())[0]['Total'];
  print('sdgfsfsdgsdfgsd ${total}');
  setState(() {
    if (total != null){
      _total = total;

    }else{
      _total = 0.0;

    }
  });
  //setState(() => );
}
  String userId,_name,_email,_mobile;
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);
      _name = prefs.getString(UserPreferences.USER_NAME);
      _email = prefs.getString(UserPreferences.USER_EMAIL);
      _mobile = prefs.getString(UserPreferences.USER_MOBILE);
      print('userID' + userId + " : " + _name + " : " + _email + " : " + _mobile);
    }
    );
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);
  }
  startPayment(double amount) async {
    var uniq = _randomString(10);
    var isConnect = await ConectionDetecter.isConnected();
      double finalTotal = amount * 100.0;
    if (isConnect) {
    if (_total == 0.0) {
      Fluttertoast.showToast(msg: "Cart Is Empty", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
    } else {

      Map<String, dynamic> options = new Map();
      options.putIfAbsent("name", () => "ShudhH2O");
      options.putIfAbsent("image", () => "https://www.73lines.com/web/image/12427");
      options.putIfAbsent("description", () => "Order Id : ${uniq}");
      options.putIfAbsent("amount", () => "${finalTotal}");
    //  options.putIfAbsent("amount", () => "${finalTotal}");
      options.putIfAbsent("email", () => "ankit.shrivastava00@gmail.com");
      options.putIfAbsent("contact", () => "9713172282");
      //Must be a valid HTML color.
      options.putIfAbsent("theme", () => "#FF0000");
      //Notes -- OPTIONAL
      Map<String, String> notes = new Map();
      notes.putIfAbsent('key', () => "value");
      notes.putIfAbsent('randomInfo', () => "haha");
      options.putIfAbsent("notes", () => notes);
      options.putIfAbsent("api_key", () => "rzp_live_jvB6dYPSWVYnEp");
      Map<dynamic,dynamic> paymentResponse = new Map();
    //  paymentResponse = await Razorpay.showPaymentForm(options);
      print("response $paymentResponse");
      String code=paymentResponse['code'];
      String message=paymentResponse['message'];
    if (code == '0'){
      Fluttertoast.showToast(
          msg: "Payment Cancel",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      checkoutData("Cancel",'${message}','${uniq}');

    ///  Navigator.of(context).pop();
    }else{
      Fluttertoast.showToast(
          msg: "Payment Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      checkoutData("Succesfully",'${message}','${uniq}');
    }
    }
  }else{
      Fluttertoast.showToast(
          msg: "Please check your internet connection....!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String> apiCallForUserProfile(String url, Map jsonMap) async {

    CustomProgressLoader.showLoader(context);

    var isConnect = await ConectionDetecter.isConnected();

    if (isConnect) {
      try {

        HttpClient httpClient = new HttpClient();
        HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.add(utf8.encode(json.encode(jsonMap)));
        HttpClientResponse response = await request.close();
        // todo - you should check the response.statusCode
        reply = await response.transform(utf8.decoder).join();
        httpClient.close();
        Map data = json.decode(reply);
        String status = data['response'];

        print('RESPONCE_DATA : '+status);
        CustomProgressLoader.cancelLoader(context);
//sh95467091
        if (status == "success") {
          DBProvider.db.deleteAll();
          Fluttertoast.showToast(
              msg: "Order Succesfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushReplacement(context
              ,new MaterialPageRoute(builder: (BuildContext context) => SuccessPage()));
          return reply;
        } else   if (status == "unsuccess") {
          Fluttertoast.showToast(
              msg: "Incorrect Mobile And Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return reply;
        } else {
          Fluttertoast.showToast(
              msg: "Incorrect Mobile And Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return  reply;
        }

      } catch (e) {
        print(e);
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        return reply;
      }
    } else {
      CustomProgressLoader.cancelLoader(context);
      Fluttertoast.showToast(
          msg: "Please check your internet connection....!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return reply;
    }
  }

@override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Cart"),

      ),
      body: FutureBuilder<List<Client>>(
        future: DBProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
            return
              Column(
                children: [

                  Expanded(child:

                  ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      item = snapshot.data[index];
                      print(item.category);

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          DBProvider.db.deleteClient(item.id);
                          _calcTotal();
                          setState(() {
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey[100],
                                      width: 1.0
                                  ),
                                  top: BorderSide(
                                      color: Colors.grey[100],
                                      width: 1.0
                                  ),
                                )
                            ),
                            height: 100.0,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 100.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5.0
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)
                                      ),
                                      image: DecorationImage(image: new AssetImage(
                                          'images/productimage.png'))
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.0,left: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(item.product_name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                                              ),
                                              Container(
                                                child: InkResponse(
                                                    onTap: (){
                                                      DBProvider.db.deleteClient(item.id);
                                                      _calcTotal();
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: 10.0),
                                                      child: Icon(Icons.remove_circle,color: Colors.red,),
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text("Price ${item.price.toString()}"),
                                          SizedBox(height: 5.0,),
                                          Text("Quantity ${item.quantity.toString()}"),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child:Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[100],
                                  width: 1.0
                              ),
                              top: BorderSide(
                                  color: Colors.grey[100],
                                  width: 1.0
                              ),
                            )
                        ),
                        height: 80.0,
                        child: Center(
                          child: Row(
                          children: <Widget>[

                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0,left: 5.0),
                                  child: Column(
                                  //  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                             child: TextFormField(
                                              controller: promocodeController,
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                hintText: 'Enter Promo Code',
                                                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                               // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                              ),
                                              ),
                                            ),
                                          ),
                                        Expanded(
                                            child: Container(
                                          width: 40.0,
                                          child:   RaisedButton(
                                              color: Colors.blue,
                                              onPressed: (){
                                              },
                                              child: Text("Apply",style: TextStyle(color: Colors.white),),
                                            ),
                                              margin: EdgeInsets.only(left: 30),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                     ),
                    ),
                  ),
                ],
              );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          height: 60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey[300],width: 1.0)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      child: Text("Total Amount",style: TextStyle(fontSize: 12.0,color: Colors.grey),),
                    ),
                    Text( "Rs. ${_total}",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600)),
                  //  Text("Rs. ${total}",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              /*  ScopedModelDescendant<AppModel>(
                    builder: (context,child,model){*/
              RaisedButton(
                color: Colors.deepOrange,
                onPressed: (){
               // checkout(DBProvider.db.getAllClientsCard());
               //   checkoutData();
                  //startPayment(_total);
                  checkoutData1();
                      },
                child: Text("Check Out",style: TextStyle(color: Colors.white),),
              ),
              //          },
              //      )
            ],
          )
      ),
    );
  }
}