import 'package:flutter/material.dart';
import 'package:shuddh2o/activity/splash_screen.dart';
import 'package:shuddh2o/activity/startscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/drawer/home_pages.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    routes: <String, WidgetBuilder>{
      '/StartScreen': (BuildContext context) => new StartScreen(),
      '/HomePage': (BuildContext context) => new HomePage(0)
    },
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primaryColor: Colors.lightBlue,
      accentColor: Colors.lightBlue,
      primaryColorBrightness: Brightness.dark,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = "FALSE";
  String path ='/StartScreen';
  SharedPreferences prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      status = prefs.getString(UserPreferences.LOGIN_STATUS);
      if (status == "TRUE") {
        // Navigator.of(context).pushReplacementNamed('/HomePage');
        path='/HomePage';
      } else {
        path ='/StartScreen';
        //Navigator.of(context).pushReplacementNamed('/StartScreen');
      }

    });

  }

   navigationPage() {
    if (status == "true") {
     // Navigator.of(context).pushReplacementNamed('/HomePage');
      path='/HomePage';
    } else {
      path ='/StartScreen';
      //Navigator.of(context).pushReplacementNamed('/StartScreen');
    }

  }
  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  //  navigationPage();
  }
  @override
  Widget build(BuildContext context) {
    return Center(child:  new SplashScreen(
      seconds: 10,
    //  navigateAfterSeconds: navigationPage() ,
     navigateAfterSeconds: path,
      imageBackground: new AssetImage("images/banner.jpg"),
      //  title:  new Text("Shuddh H2o"),
      image: new Image(image: new AssetImage("images/launcher.gif")),
      // image: new Image.asset(name),
      // image: new Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcxx9ypeeGCqaz5GJXY6gMoGIFlfeqKRQvXltqFA66_mSNPHBkPg'),
      // image: new Image.network('https://flutter.io/images/catalog-widget-placeholder.png'),
      gradientBackground: new LinearGradient(
          colors: [Colors.cyan, Colors.white10],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.transparent,
      photoSize: 100.0,

    ),
      //  loaderColor: Colors.red,
    );
  }
}

