import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'dart:async';
import 'dart:io';
import 'package:shuddh2o/common/CustomProgressDialog.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  //For subscription to the ConnectivityResult stream

  String reply;
  Response response;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

//  SharedPreferences prefs;

  String _mobile, _password;
  var map, ownerMap;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  void _performLogin() {
    try {final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      try {
        /*apiCallForUserProfile(_first_name,_last_name, _mobile, _email, _city, _address, _state,
          _password, '132134343434343434343');*/
        String url =
            'https://stark-hamlet-82159.herokuapp.com/forgot';
        Map map = {
          "Email":_mobile
        };

        apiRequest(url, map);
      } catch (e) {
        print(e.toString());
      }

    }
    } catch (e) {
      print(e.toString());
    }

    /* final snackbar = SnackBar(
      content: Text('Email: $_email, password: $_password'),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);*/
  }

/*  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(UserPreferences.USER_ID);
  }*/

  Future<String> apiRequest(String url, Map jsonMap) async {
    try {
      CustomProgressLoader.showLoader(context);

      var isConnect = await ConectionDetecter.isConnected();
      if (isConnect) {
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

        if (status == "3") {
          Fluttertoast.showToast(
              msg: "Email Not Verified",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          return reply;
        } else  if (status == "1") {
          Fluttertoast.showToast(
              msg: "Login",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          return  reply;
        }else /* if (status == "2") {
          Fluttertoast.showToast(
              msg: "Email Not Register",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }else*/  if (status == "4") {
          Fluttertoast.showToast(
              msg: "Incorrect Email And Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }else   {
          Fluttertoast.showToast(
              msg: "Try Again Some Thing Is Wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

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
        // ToastWrap.showToast("Please check your internet connection....!");
        // return response;
      }
    } catch (e) {
      CustomProgressLoader.cancelLoader(context);
      print(e);
      return reply;
    }
  }

  @override
  Widget build(BuildContext context) {


    final forgotLabel = FlatButton(
      child: Text(
        "Don't worry! Just Enter Your Number Below "
            "And we'll send  you the  password reset instrucation",
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),

    );
    final loginButton = Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('images/logo.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
    );
    final verifyButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          // Navigator.of(context).pushNamed(Login());
          /*         Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => HomePage()));*/
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Verify', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                loginButton,
                forgotLabel,
                   TextFormField(
                  decoration: InputDecoration(labelText: 'Number'),
                  validator: (valueMobile) =>
                  valueMobile.length != 10 ? 'Enter Correct Number' : null,
                    // !valueMobile.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (valueMobile) => _mobile = valueMobile,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),

                new Container(
                    child: new SizedBox(
                      width: double.infinity,

                      child: new RaisedButton(
                        onPressed: _performLogin,
                        textColor: Colors.white,
                        child: new Text("RESET PASSWORD"),
                        color: Colors.blue,
                        padding: new EdgeInsets.all(15.0),
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
