import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/activity/forgot.dart';
import 'package:shuddh2o/activity/otp.dart';
import 'package:shuddh2o/activity/startscreen.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'package:shuddh2o/common/CustomProgressDialog.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/drawer/home_pages.dart';
import 'package:shuddh2o/model/login_model.dart';

import 'package:flutter/services.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _formWasEdited = false;

  List<userDetail> list = List();

  GoogleSignInAccount _currentUser;
  String _contactText,reply;
  Response response;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

 // SharedPreferences prefs;

  var map, ownerMap;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      // fetchData();
      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin();
    }
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    final RegExp phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }
  void _performLogin() {
    //  _incrementCounter(_email);
    try {
      if (emailController.text.isEmpty) {

        Fluttertoast.showToast(msg: "Enter Your Number", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
      } else  if (emailController.text.length!=10) {

        Fluttertoast.showToast(msg: "Enter Correct Number", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
      } else if (passwordController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Your Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // registrationTask(_mobile);
        String url ="https://sheltered-woodland-33544.herokuapp.com/loginWebService";

        Map map = {

          "password":passwordController.text,
          "mobile":emailController.text
        };

        apiCallForUserProfile(url, map);
      }
    } catch (e) {
     print(e.toString());
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

         print('RESPONCE_DATA : '+status);
         CustomProgressLoader.cancelLoader(context);

        if (status == "success") {
          Fluttertoast.showToast(
              msg: "Login",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          String token = data["token"].toString();
          for (var word in data['result']) {
            prefs.setString(UserPreferences.USER_ID,word['_id'].toString().trim());
            prefs.setString(UserPreferences.USER_NAME,word['name'].toString().trim());
            prefs.setString(UserPreferences.USER_EMAIL,word['email'].toString().trim());
            prefs.setString(UserPreferences.USER_MOBILE,word['mobile'].toString().trim());
          }
          prefs.setString(UserPreferences.LOGIN_STATUS,"TRUE");
          prefs.setString(UserPreferences.USER_TOKEN,token);

          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (BuildContext context) => HomePage(0)));

          return reply;
        } else  if (status == "please submit otp") {
          Fluttertoast.showToast(
              msg: "Login",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          String token = data["token"];
          for (var word in data['result']) {

            prefs.setString(UserPreferences.USER_ID,word['_id'].toString().trim());
            prefs.setString(UserPreferences.USER_NAME,word['name'].toString().trim());
            prefs.setString(UserPreferences.USER_EMAIL,word['email'].toString().trim());
            prefs.setString(UserPreferences.USER_MOBILE,word['mobile'].toString().trim());
          }
          prefs.setString(UserPreferences.USER_TOKEN,token);

          Navigator.pushReplacement(context
              ,new MaterialPageRoute(builder: (BuildContext context) => Otp()));
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

  Widget _buildBody() {
    if (_currentUser != null) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Registration'),
          backgroundColor: Colors.lightBlue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: _currentUser,
              ),
              title: Text(_currentUser.displayName),
              subtitle: Text(_currentUser.email),
            ),
            const Text("Signed in successfully."),
            Text(_contactText),
            RaisedButton(
              child: const Text('SIGN OUT'),
              onPressed: _handleSignOut,
            ),
            RaisedButton(
              child: const Text('REFRESH'),
              onPressed: _handleGetContact,
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.lightBlue,
        ),
        body: Card(
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (valueName) => valueName.length <= 0
                              ? 'Enter Your Number'
                              : null,
                          //   !val.contains('@') ? 'Not a valid email.' : null,
                     //     onSaved: (valueName) => _mobile = valueName,
                          keyboardType: TextInputType.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RaisedButton(
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (formKey.currentState.validate()) {
                                // If the form is valid, we want to show a Snackbar
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RaisedButton(
                            child: const Text('Gmail Login'),
                            onPressed: _handleSignIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => StartScreen()));

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

    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.number,

      inputFormatters: <TextInputFormatter> [
        WhitelistingTextInputFormatter.digitsOnly,
        // Fit the validating format.
     //   _phoneNumberFormatter,
      ],
      autofocus: false,
      maxLines: 1,
      maxLength: 10,
      decoration: InputDecoration(
        hintText: 'Enter Your Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),

    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'Enter Your Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          // Navigator.of(context).pushNamed(Login());
          /*Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Otp()));*/
          _performLogin();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final gmailButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _handleSignIn,
        /*onPressed: () {
          // Navigator.of(context).pushNamed(Login());
          _handleSignIn();
        },*/
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Gmail Login', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    Forgot()));
      },
    );

    final orLabel = FlatButton(
      child: Text(
        'OR',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return new WillPopScope(
        onWillPop: _onWillPop,
        child:new Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.lightBlue,
        leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new StartScreen(),
          ));
        }),
        automaticallyImplyLeading: false,
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
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              forgotLabel
             // orLabel,
             // gmailButton
            ],
          ),
        ),
        //   ),
        //],
      ),
      ),
    );
  }
}
