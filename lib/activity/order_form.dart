import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/activity/success_page.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'dart:io';
import 'dart:async';
import 'package:shuddh2o/common/Constants.dart';
import 'package:shuddh2o/common/CustomProgressDialog.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/model/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class OrderForm extends StatefulWidget {
  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  Response response;
  String reply;
  String dropdownValue = '1';
  List<String> _dropdownValues = List();
  String _first_name, _last_name, _mobile, _email, _Cans, _address;
  String _currentlySelected = "Choose time slot";
  String _currentlydays = "Choose days slot";
  var map, ownerMap;

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      checkOut();
    }
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);
      print('userID' + userId);
    });
  }

  List<OrderModel> list = List();
  List<String> itemlist = [];
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://sheltered-woodland-33544.herokuapp.com/viewproduct");
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
    //_fetchData();
    super.initState();
    getSharedPreferences();
    TimeSlot(Constants.TIMESLOT);
  }

  void checkOut() {
    //  _incrementCounter(_email);
    try {
      // registrationTask(_mobile);
      String url = "https://sheltered-woodland-33544.herokuapp.com/bulkorder";
      Map map = {
        "name": _first_name,
        "email": _email,
        "mobile": _mobile,
        "address": _address,
        "qauntity": _Cans,
        "timeslot": _currentlySelected,
        "startdate": selectedFromDate.toString(),
        "enddate": selectedToDate.toString()
      };

      apiCallForUserProfile(url, map);
    } catch (e) {
      print(e.toString());
    }
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

  Future<String> apiCallForUserProfile(String url, Map jsonMap) async {
    CustomProgressLoader.showLoader(context);
    var isConnect = await ConectionDetecter.isConnected();
    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
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

        if (status == "success") {
          Fluttertoast.showToast(
              msg: "Your Request Has Been Sent",
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
              msg: "Server Not Responding",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return reply;
        } else {
          Fluttertoast.showToast(
              msg: "Try Again",
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
  DateTime selectedToDate = DateTime.now();
  DateTime selectedFromDate = DateTime.now();

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2050, 12));
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;
      });
  }

  Future<Null> _selectedFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2050, 12));
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        // padding: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.fromLTRB(17.0, 2.0, 17.0, 17.0),
        child: Form(
          key: formKey,
          child: new ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name *'),
                validator: (valueName) =>
                    valueName.length <= 0 ? 'Enter Your Full Name' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueName) => _first_name = valueName,
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email *'),
                validator: (valueEmail) =>
                    //valueEmail.length <= 0 ? 'Enter Your Email' : null,
                    !valueEmail.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueEmail) => _email = valueEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile *'),
                validator: (valueMobile) =>
                    valueMobile.length != 10 ? 'Enter Correct Number' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueMobile) => _mobile = valueMobile,
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
              TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Enter Number of Cans *'),
                  validator: (valueCans) =>
                      valueCans.length <= 0 ? 'Enter Your Cans' : null,
                  onSaved: (valueCans) => _Cans = valueCans,
                  keyboardType: TextInputType.number,
                  maxLength: 3),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address *'),
                validator: (valueAddress) =>
                    valueAddress.length <= 0 ? 'Enter Your Cans' : null,
                onSaved: (valueAddress) => _address = valueAddress,
                keyboardType: TextInputType.text,
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
              new Container(
                padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new Text("To Date : "),
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 5.0),
                    ),
                    new Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                        child: new SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: FlatButton.icon(
                              icon: Icon(Icons.calendar_today),
                              label: Text("${new DateFormat("yyyy-MM-dd").format(selectedToDate)}"), //`Text` to display
                               //label: Text("29/06/2019"), //`Text` to display
                              onPressed: () {
                                _selectToDate(context);
                              },
                            ),
                          ),
                        ),
                        margin: EdgeInsets.only(right: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new Text("From Date : "),
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                    ),
                    new Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                        child: new SizedBox(
                          width: double.infinity,
                          child: new Center(
                            child: FlatButton.icon(
                              icon: Icon(Icons.calendar_today),
                                label: Text("${new DateFormat("yyyy-MM-dd").format(selectedFromDate)}"), //`Text` to display
                              onPressed: () {
                                //Code to execute when Floating Action Button is clicked
                                //...
                                _selectedFromDate(context);
                              },
                            ),
                          ),
                        ),
                        margin: EdgeInsets.only(right: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                  child: new SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: _submit,
                      textColor: Colors.white,
                      child: new Text("ORDER NOW"),
                      color: Colors.blue,
                      padding: new EdgeInsets.all(20.0),
                    ),
                  ),
                  margin: new EdgeInsets.all(15.0)),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
