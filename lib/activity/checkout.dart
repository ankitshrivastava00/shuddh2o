import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_plugin/razorpay_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/success_page.dart';
import 'package:shuddh2o/common/Constants.dart';
import 'package:shuddh2o/common/CustomProgressDialog.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/common/radio_button/grouped_buttons.dart';

class CheckOutPgae extends StatefulWidget {
  String total,
      discount,
      paid,
      coupncode,
      productid,
      productname,
      productprice,
      productquantity;

  CheckOutPgae(
      this.total,
      this.discount,
      this.paid,
      this.coupncode,
      this.productid,
      this.productname,
      this.productprice,
      this.productquantity);

  @override
  CheckOutPgaeState createState() => CheckOutPgaeState();
}

class CheckOutPgaeState extends State<CheckOutPgae> {
  TextEditingController em = new TextEditingController();
  TextEditingController land = new TextEditingController();
  TextEditingController pin = new TextEditingController();
  String radiovalue = "", delievrytype = "";
  String reply,paidamount="0.0";
  DBProvider db;
  List<String> _dropdownValues = List();
  String _currentlySelected = "Choose time slot";

  DateTime selectedToDate = DateTime.now();
  DateTime selectedFromDate = DateTime.now();
  double addamt = 0.0,pdamt=0.0,caltotal=0.0;

  Future checkout(_context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(delievrytype == "Express"){
      Map map = {
        "userid": '${prefs.getString(UserPreferences.USER_ID)}',
        "coupancode": '${widget.coupncode}',
        "totalamount": '${widget.total}',
        "discountamount": '${widget.discount}',
        "paidamount": '${paidamount}',
        "address": '${em.text}',
        "landmark": '${land.text}',
        "pincode": '${pin.text}',
        "paymentmode": '${radiovalue}',
        "delievrytype": '${delievrytype}',
        "productid": '${widget.productid}',
        "productname": '${widget.productname}',
        "productPrice": '${widget.productprice}',
        "productQuantity": '${widget.productquantity}',
        "additional_amt": '${addamt}',
      };
      placeOrder(Constants.ORDER_API, map, _context);
    }else if(delievrytype == "Scheduled"){
      Map map = {
        "userid": '${prefs.getString(UserPreferences.USER_ID)}',
        "coupancode": '${widget.coupncode}',
        "totalamount": '${widget.total}',
        "discountamount": '${widget.discount}',
        "paidamount": '${paidamount}',
        "address": '${em.text}',
        "landmark": '${land.text}',
        "pincode": '${pin.text}',
        "paymentmode": '${radiovalue}',
        "delievrytype": '${delievrytype}',
        "productid": '${widget.productid}',
        "productname": '${widget.productname}',
        "productPrice": '${widget.productprice}',
        "productQuantity": '${widget.productquantity}',
        "additional_amt": '${addamt}',
        "scheduled_startdate": selectedToDate.toString(),
        "scheduled_enddate": selectedFromDate.toString(),
        "scheduled_timeslot": _currentlySelected,
      };
      placeOrder(Constants.ORDER_API, map, _context);
    }

  }

  Future<String> placeOrder(String url, Map jsonMap, _context) async {
    try {
      CustomProgressLoader.showLoader(_context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['response'].toString();

      CustomProgressLoader.cancelLoader(_context);

      if (status == "success") {
        DBProvider.db.deleteAll();
        setState(() {});
        Fluttertoast.showToast(
            msg: "Order Placed Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.lightBlue,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pushReplacement(
            _context,
            new MaterialPageRoute(
                builder: (BuildContext context) => SuccessPage()));
      }
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
      CustomProgressLoader.cancelLoader(context);
      print(e);
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
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });
  }

  startPayment(double amount, _context) async {
    var uniq = _randomString(10);
    //   var isConnect = await ConnectionDetector.isConnected();
    double finalTotal = amount * 100.0;
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Ricwal");
    options.putIfAbsent(
        "image", () => "https://www.73lines.com/web/image/12427");
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
    Map<dynamic, dynamic> paymentResponse = new Map();
    paymentResponse = await Razorpay.showPaymentForm(options);
    print("response $paymentResponse");
    String code = paymentResponse['code'];
    String message = paymentResponse['message'];
    if (code == '0') {
      Fluttertoast.showToast(
          msg: "Payment Cancel",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Payment Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      checkout(context);
    }

    /*  }else{
      Fluttertoast.showToast(
          msg: "Please check your internet connection....!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }*/
  }
  Future<String> apiCallForUserProfile(String url, Map jsonMap) async {
    CustomProgressLoader.showLoader(context);
    //   var isConnect = await ConnectionDetector.isConnected();
    //  if (isConnect) {
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

      print('RESPONCE_DATA : ' + status);
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

        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => SuccessPage()));
        return reply;
      } else if (status == "unsuccess") {
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
        return reply;
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

    /* } else {
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
    }*/
  }
  void show() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {},
            ),
          ],
        );
      },
    );

    /* //    if (emailController.text.isEmpty) {
                  */ /*   if (pickUpLocation == "Enter Your Pick Up Location" || pickUpLocation.isEmpty || destinationUpLocation == null) {

                              Fluttertoast.showToast(
                                  msg: "Enter PickUp Address",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (destinationUpLocation == "Enter Your Destination Location" ||  destinationUpLocation.isEmpty || destinationUpLocation == null) {

                              Fluttertoast.showToast(
                                  msg: "Enter Destination",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {*/ /*

                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                        new Text("Pickup Request",style: TextStyle(fontSize: 20.0,color: Colors.black,fontWeight:FontWeight.w600 ),),

                        */ /*content: SingleChildScrollView(
                          child: new Column(
                            children: <Widget>[

                              new Container(
                                padding:EdgeInsets.fromLTRB(0.0,12.0,0.0,0.0),

                                child:
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            image: new AssetImage('images/to.png'),
                                          )
                                      ),
                                      margin: EdgeInsets.only(left: 10.0),
                                    ),

                                    new Expanded(

                                      child: new Container(
                                        padding:EdgeInsets.fromLTRB(12.0,0.0,12.0,0.0),

                                        child: new SizedBox(
                                          width: double.infinity,
                                          child: new  Text('area}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,),
                                          ),


                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              new Row(
                                children: <Widget>[
                                  new Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage('images/dots.png'),
                                        )
                                    ),
                                    margin: EdgeInsets.only(left: 0.0),
                                  ),
                                  new Expanded(

                                    child: new Container(

                                      child: new SizedBox(
                                        width: double.infinity,
                                        child:      new  Text('',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,

                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,),
                                        ),
                                      ),
                                    ),
                                  ),],
                              ),
                              new Container(
                                padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0),

                                child:
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: new BoxDecoration(
                                        // shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            //     fit: BoxFit.fill,
                                            image: new AssetImage('images/pin.png'),
                                          )
                                      ),
                                      margin: EdgeInsets.only(left: 10.0),
                                    ),
                                    new Expanded(

                                      child: new Container(
                                        padding:EdgeInsets.fromLTRB(12.0,0.0,12.0,0.0),

                                        child: new SizedBox(
                                          width: double.infinity,
                                          child:      new  Text('qweqw',
                                            //  maxLines: 1,
                                            // overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),*/ /*
                        actions: <Widget>[
                          FlatButton(
                            child: Text('CANCEL',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ), FlatButton(
                            child: Text('Enter delivery details',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                              ),
                            ),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );*/
  }
  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You will never be satisfied.'),
                Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2050, 12));

    if (picked != null && picked != selectedToDate){
      setState(() => selectedToDate = picked);

    }
  }

  Future<Null> _selectedFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2050, 12));

    if (picked != null && picked != selectedFromDate){
      setState(() => selectedFromDate = picked);
    }


  }

  void express() {
    setState(() {
      setState(() => addamt = 10.0);
      setState(() => paidamount = (double.parse(widget.paid)+addamt).toString());
    });
  }

  void scheduled() {
    setState(() {
      setState(() => addamt = 0.0);
      setState(() => paidamount = '${widget.paid}');
    });
  }

  Future<String> TimeSlot(String url) async {
    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['status'].toString();
      for (var word in data['detail']) {
        String title = word["title"].toString();
        setState(() {
          _dropdownValues.add(title);
        });
      }
      print('RESPONCE_DATA : ' + status);
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TimeSlot(Constants.TIMESLOT);
    setState(() => paidamount = '${widget.paid}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.lightBlue,
        title: new Text("Check Out"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  'Your Bill :',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                  child: new Card(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Total Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            "Rs."
                            '${widget.total}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Discount Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            "Rs."
                            '${widget.discount}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Other Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 5.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            "Rs." '${addamt}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Paid Amount :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 50.0, 5.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            "Rs." '${paidamount}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 2.0, 50.0, 2.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  "Enter Address",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 10.0),
                child: new TextField(
                  controller: em,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Address For Delievery',
                    labelStyle: theme.textTheme.caption
                        .copyWith(color: Colors.lightBlue),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 10.0),
                child: new TextField(
                  controller: land,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Landmark',
                    labelStyle: theme.textTheme.caption
                        .copyWith(color: Colors.lightBlue),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 10.0),
                child: new TextField(
                  controller: pin,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    labelStyle: theme.textTheme.caption
                        .copyWith(color: Colors.lightBlue),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 2.0, 20.0, 2.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  "Select delievery type",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                alignment: Alignment.topLeft,
                child: RadioButtonGroup(
                  labels: <String>[
                    "Express",
                    "Scheduled",
                  ],
                  onSelected: (String selected) => delievrytype = selected,
                  onChange: (val, i) {
                    if (i == 0) {
                      Fluttertoast.showToast(
                          msg: '${val}',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      setState(() => double.parse('${widget.total}') + 10.0);
                      express();
                    } else {
                      scheduled();
                      Fluttertoast.showToast(
                          msg: '${val}',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                            new Text("Choose Your scheduled date for delievery",
                              style: TextStyle(fontSize: 20.0,color: Colors.black,
                                  fontWeight:FontWeight.w600 ),),

                            content: SingleChildScrollView(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                  //  padding:EdgeInsets.fromLTRB(0.0,12.0,0.0,0.0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Container(
                                          child: new Text("To Date : "),
                                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                        ),
                                        new Expanded(
                                          child: new Container(
                                            padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                            child: new SizedBox(
                                              width: double.infinity,
                                              child: new FlatButton.icon(
                                                icon: Icon(Icons.calendar_today),
                                                label: Text(
                                                    "${new DateFormat("yyyy-MM-dd").format(selectedToDate)}"),
                                                //`Text` to display
                                                onPressed: () {
                                                  _selectToDate(context);
                                                  setState(() {

                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                   // padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0),
                                    child:
                                    new Row(
                                      children: <Widget>[
                                        new Container(
                                          child: new Text("From Date : "),
                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                                        ),
                                        new Expanded(
                                          child: new Container(
                                            padding:EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                            child: new SizedBox(
                                              width: double.infinity,
                                              child:
                                              new FlatButton.icon(
                                                icon: Icon(Icons.calendar_today),
                                                label: Text(
                                                    "${new DateFormat("yyyy-MM-dd").format(selectedFromDate)}"),
                                                //`Text` to display
                                                onPressed: () {
                                                  _selectedFromDate(context);
                                                  setState(() {

                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                    child: DropdownButton(
                                      hint: Text(
                                        '${_currentlySelected}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black45),
                                      ),
                                      isExpanded: false,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _currentlySelected = newValue;
                                        });
                                      },
                                      items: _dropdownValues.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      // value: _dropdownValues.first,
                                    ),
                                    height: 60.0,
                                  ),
                                ],
                              ),
                            ),

                          );
                        },
                      );
                    }
                  },
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 2.0, 20.0, 2.0),
                alignment: Alignment.topLeft,
                child: new Text(
                  "Select Payment mode",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                alignment: Alignment.topLeft,
                child: RadioButtonGroup(labels: <String>[
                  "Cash On Delievery",
                  "Online",
                ], onSelected: (String selected) => radiovalue = selected),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 20.0),
                child: new Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.lightBlue,
                  child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      onPressed: () {
                        if (radiovalue == "Cash On Delievery") {
                          checkout(context);
                        } else if (radiovalue == "Online") {
                          double pd = double.parse('${widget.paid}');
                          startPayment(pd, context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please fill all essential fields",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Text(
                        "Place Order",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
