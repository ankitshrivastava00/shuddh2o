import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shuddh2o/activity/startscreen.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'package:shuddh2o/common/CustomProgressDialog.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId,reply;
  Response response ;
//  SharedPreferences prefs;

  String _name,
      _mobile,
      _email,
      _password,
      _city,
      _address,
      _state,
      _lat,
      _long,
      _IEMI,
      _deviceId;
  var map, ownerMap;
  bool _isLoading = false;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      // fetchData();
      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      String url ="https://sheltered-woodland-33544.herokuapp.com/signupWebService";

      Map map = {
        "name": _name,
        "email": _email,
        "mobile": _mobile,
        "city": _city,
        "address": _address,
        "state": _state,
        "lat": "21.121211",
        "long": "73.12222",
        "IEMI": "7878787878787",
        "password": _password,
        "deviceId": "deviceId"
      };

      apiCallForUserProfile(url, map);

    }
  }

  /*_incrementCounter(String mob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    *//*int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');*//*
    await prefs.setString("MOBILE", mob);
  }*/

/*  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(UserPreferences.USER_ID);
  }*/


  Future<String> apiCallForUserProfile(String url, Map jsonMap) async {
      var isConnect = await ConectionDetecter.isConnected();
      CustomProgressLoader.showLoader(context);

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
      String status = data['response'].toString().trim();

      print('RESPONCE_DATA : '+status);
      CustomProgressLoader.cancelLoader(context);
      print('sdfssfsf'+response.toString());


        if (status == "user allredy resister") {
          Fluttertoast.showToast(
              msg: "Number Allready Registered",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

     //     return reply;
        } else if (status == "success") {
          Fluttertoast.showToast(
              msg: "Regitration Succesfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        /*  Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) => Otp()));*/
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (BuildContext context) => StartScreen()));
          // return reply;
        } else {
          Fluttertoast.showToast(
              msg: "Try Again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
      //    return reply;
        }

    } catch (e) {
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
  //    return reply;
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
 //   return reply;
      }
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => StartScreen()));

  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: _onWillPop,child:
      Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.lightBlue,
        leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new StartScreen(),
          ));
        }),
        automaticallyImplyLeading: false,
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Container(
               //      child: new Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcxx9ypeeGCqaz5GJXY6gMoGIFlfeqKRQvXltqFA66_mSNPHBkPg'),
                    ),
                new Image.asset('images/logo.png'),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (valueName) =>
                      valueName.length <= 0 ? 'Enter Your Name' : null,
                  //   !val.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueName) => _name = valueName,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (valueEmail) =>
                     // valueEmail.length <= 0 ? 'Enter Your Email':null,
                  !valueEmail.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueEmail) => _email = valueEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (valuePassword) =>
                      valuePassword.length < 6 ? 'Password too short.' : null,
                  onSaved: (valuePassword) => _password = valuePassword,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile'),
                  inputFormatters: <TextInputFormatter> [
                    WhitelistingTextInputFormatter.digitsOnly,
                    // Fit the validating format.
                    //   _phoneNumberFormatter,
                  ],
                  validator: (valueMobile) =>
                      valueMobile.length != 10 ? 'Enter Correct Number' : null,
                  //   !val.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueMobile) => _mobile = valueMobile,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (valueAddress) =>
                      valueAddress.length <= 0 ? 'Enter Your Address' : null,
                  //   !val.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueAddress) => _address = valueAddress,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (valueCity) =>
                      valueCity.length <= 0 ? 'Enter Your City' : null,
                  //   !val.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueCity) => _city = valueCity,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'State'),
                  validator: (valueState) =>
                      valueState.length <= 0 ? 'Enter Your State' : null,
                  //   !val.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueState) => _state = valueState,
                  keyboardType: TextInputType.text,
                ),
                new Container(
                    child: new RaisedButton(
                      onPressed: _submit,
                      textColor: Colors.white,
                      child: new Text("Registration"),
                      color: Colors.lightBlue,
                      padding: new EdgeInsets.all(5.0),
                    ),
                    margin: new EdgeInsets.all(15.0)
                ),
              ],
            ),
          ),
        ),

      ),
      ),
    );
  }
}
