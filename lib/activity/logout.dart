import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/startscreen.dart';
import 'package:shuddh2o/common/UserPreferences.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DBProvider.db.deleteAll();
    logout();
  }


  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
    Fluttertoast.showToast(
        msg: "Logout",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                StartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Scaffold(

      backgroundColor: Colors.white,
      body:
        new Text("Logout"),

    );
  }
}
