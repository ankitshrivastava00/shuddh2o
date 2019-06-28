import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'package:shuddh2o/common/Constants.dart';
import 'package:shuddh2o/common/CustomProgressDialog.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/drawer/home_pages.dart';

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String reply;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  TextEditingController otpController = new TextEditingController();

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
      _token,
      _deviceId;
  var map, ownerMap;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();
  }
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);
      _token = prefs.getString(UserPreferences.USER_TOKEN);
    });
  }

  void _performLogin() {
    //  _incrementCounter(_email);
    try {
      if (otpController.text.isEmpty) {

        Fluttertoast.showToast(msg: "Enter otp", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
      }  else {
        // registrationTask(_mobile);

        Map map = {

          "otp":otpController.text,
          "id":userId,
        };

        apiCallForUserProfile(Constants.BASE_URL+Constants.OTP_VERIFY, map,_token);
      }
    } catch (e) {
      print(e.toString());
    }

  }


  Future<String> apiCallForResend(String url, Map jsonMap,String token) async {

    CustomProgressLoader.showLoader(context);

    var isConnect = await ConectionDetecter.isConnected();

    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        HttpClient httpClient = new HttpClient();
        HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.headers.set('authorization', token);
        request.add(utf8.encode(json.encode(jsonMap)));
        HttpClientResponse response = await request.close();
        // todo - you should check the response.statusCode
        reply = await response.transform(utf8.decoder).join();
        httpClient.close();
        Map data = json.decode(reply);
        String status = data['response'];

        print('RESPONCE_DATA : '+status);
        CustomProgressLoader.cancelLoader(context);

       /* if (status == "otpsuccess") {
          Fluttertoast.showToast(
              msg: "Otp Verify",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          prefs.setString(UserPreferences.LOGIN_STATUS,"TRUE");

          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (BuildContext context) => HomePage(0)));

          return reply;
        } else  {*/
          Fluttertoast.showToast(
              msg: "Otp Send",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

      /*    return reply;
        }
*/
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
  Future<String> apiCallForUserProfile(String url, Map jsonMap,String token) async {

    CustomProgressLoader.showLoader(context);

    var isConnect = await ConectionDetecter.isConnected();

    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        HttpClient httpClient = new HttpClient();
        HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.headers.set('authorization', token);
        request.add(utf8.encode(json.encode(jsonMap)));
        HttpClientResponse response = await request.close();
        // todo - you should check the response.statusCode
        reply = await response.transform(utf8.decoder).join();
        httpClient.close();
        Map data = json.decode(reply);
        String status = data['response'];

        print('RESPONCE_DATA : '+status);
        CustomProgressLoader.cancelLoader(context);

        if (status == "otpsuccess") {
          Fluttertoast.showToast(
              msg: "Otp Verify",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          prefs.setString(UserPreferences.LOGIN_STATUS,"TRUE");

          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (BuildContext context) => HomePage(0)));

          return reply;
        } else  {
          Fluttertoast.showToast(
              msg: "Otp Not Matched",
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('images/logo.png'),
      ),
    );

    final otpEditText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: otpController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Otp',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final verifyButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _performLogin();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Verify', style: TextStyle(color: Colors.white)),
      ),
    );

    final resendButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Map map = {
            "id":userId,
          };

          apiCallForResend(Constants.BASE_URL+Constants.RESENT_OTP, map,_token);
          },
        /*onPressed: () {
          // Navigator.of(context).pushNamed(Login());
          _handleSignIn();
        },*/
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Resend', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Otp'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.white,
      body:
          /* new Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/banner.jpg"),
              fit: BoxFit.cover,
            ),
          ),

        ),*/
          new Center(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              otpEditText,
              SizedBox(height: 24.0),
              verifyButton,
              resendButton
            ],
          ),
        ),
        //   ),
        //],
      ),
    );
  }
}
