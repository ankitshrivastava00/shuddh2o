import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/common/Connectivity.dart';
import 'package:shuddh2o/common/Constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shuddh2o/common/CustomProgressDialog.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/model/profile_model.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  Response response;
  String reply;

  List<ProfileModel> list = List();
  var isLoading = false;
//  SharedPreferences prefs;

  String _first_name, _email, _token,_mobile, _city, _address, _state;
  var map, ownerMap;

  _fetchData(String token,String UserID) async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get(Constants.BASE_URL + Constants.VIEW_PROFILE+UserID,
      headers: {HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader : "application/json"},
    );

    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new ProfileModel.fromJson(data))
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
    super.initState();
    getSharedPreferences();
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);
       _token = prefs.getString(UserPreferences.USER_TOKEN);
      _fetchData(_token,userId);
     });
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _performLogin(_token,userId);
    }
  }

  void _performLogin(String TokenID,String UserID) {
    try {
      String url = Constants.BASE_URL + Constants.UPDATE_PROFILE;
      Map map = {
        "name": _first_name ,
        "id": UserID,
        "email": _email,
        "city": _city,
        "address": _address,
        "state": _state,
      };

      apiRequest(url, map,TokenID);
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

  Future<String> apiRequest(String url, Map jsonMap,String TokenID) async {
    try {
      CustomProgressLoader.showLoader(context);

      var isConnect = await ConectionDetecter.isConnected();
      if (isConnect) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        HttpClient httpClient = new HttpClient();
        HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', TokenID);
        request.add(utf8.encode(json.encode(jsonMap)));
        HttpClientResponse response = await request.close();
        // todo - you should check the response.statusCode
        reply = await response.transform(utf8.decoder).join();
        httpClient.close();
        Map data = json.decode(reply);
        String status = data['response'];

        CustomProgressLoader.cancelLoader(context);

        if (status == "success") {
          Fluttertoast.showToast(
              msg:
                  "Update Succesfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          prefs.setString(UserPreferences.USER_NAME,'${_first_name}');
          prefs.setString(UserPreferences.USER_EMAIL,'${_email}');
         // Navigator.of(context).pop();
          return reply;
        }  else {
          Fluttertoast.showToast(
              msg: "Failed Try Again",
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
            msg: "Please Check Your Internet Connection....!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // ToastWrap.showToast("Please check your internet connection....!");
         return reply;
      }
    } catch (e) {
      CustomProgressLoader.cancelLoader(context);
      print(e);
      return reply;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Padding(
      padding: EdgeInsets.all(16.0),
      child:  new SizedBox(
        width: double.infinity,
        child:RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        onPressed: () {

          _submit();
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Update', style: TextStyle(color: Colors.white)),
      ),
      ),
    );
    return  new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
      :Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
            //   child: new Column(
            //padding: EdgeInsets.all(25.0),

            child: new Column(children: <Widget>[

        new  Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: new Stack(fit: StackFit.loose, children: <Widget>[
            new Container(
              constraints: new BoxConstraints.expand(
                height: 150.0,
              ),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('images/profilebackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child:new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          image:new AssetImage('images/man.png'),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              ),
            ),
],),),

          new  Padding(
            padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,5.0),
          //  padding: const EdgeInsets.all(16.0),
            child:
            new TextFormField(
              initialValue: list[0].name,

              decoration: InputDecoration(labelText: 'Full Name'),
              validator: (valueName) =>
              valueName.length <= 0 ? 'Enter Your Full Name' : null,
              //   !val.contains('@') ? 'Not a valid email.' : null,
              onSaved: (valueName) => _first_name = valueName,
              keyboardType: TextInputType.text,
            ),
              ),
          new  Padding(
            padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,5.0),
            child:

              TextFormField(
                initialValue: list[0].email,

                decoration: InputDecoration(labelText: 'Email'),
                validator: (valueEmail) =>
                    //valueEmail.length <= 0 ? 'Enter Your Email' : null,
                    !valueEmail.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueEmail) => _email = valueEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              ),

          new  Padding(
            padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,5.0),
            child:TextFormField(
              initialValue: list[0].mobile,

              decoration: InputDecoration(labelText: 'Mobile'),

                validator: (valueMobile) =>
                    valueMobile.length != 10 ? 'Enter Correct Number' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueMobile) => _mobile = valueMobile,
                keyboardType: TextInputType.number,
              obscureText: false,
              enabled: false,

            ),
              ),
          new  Padding(
            padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,5.0),
            child:TextFormField(
              initialValue: list[0].address,

              decoration: InputDecoration(labelText: 'Address'),
                validator: (valueAddress) =>

              valueAddress.length  <= 0  ? 'Enter Address' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress) => _address = valueAddress,
                keyboardType: TextInputType.text,
              ),
              ),
        new  Padding(
          padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,5.0),
            child:TextFormField(
              initialValue: list[0].city,

              decoration: InputDecoration(labelText: 'City'),
                validator: (valueCity) =>
                valueCity.length <= 0 ? 'Enter City' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueCity) => _city = valueCity,
                keyboardType: TextInputType.text,
              ),
              ),
        new  Padding(
          padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,5.0),
            child:TextFormField(
              initialValue: list[0].state,

              decoration: InputDecoration(labelText: 'State'),
                validator: (valueState) =>
                valueState.length <= 0 ? 'Enter State' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueState) => _state = valueState,
                keyboardType: TextInputType.text,
              ),
              ),
              loginButton,
            ],
          ),
        ),
        // ),

    ),

      ),


    );
  }
}
