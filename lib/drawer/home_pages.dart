import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/Cart.dart';
import 'package:shuddh2o/activity/logout.dart';
import 'package:shuddh2o/activity/order_form.dart';
import 'package:shuddh2o/activity/profile_edit.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:shuddh2o/fragment/all_categories_fragment.dart';
import 'package:shuddh2o/fragment/order_fragment.dart';
import 'package:shuddh2o/fragment/refer_earn.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  int title;
  HomePage(this.title);
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
  //  new DrawerItem("Water", Icons.child_friendly),
    new DrawerItem("Order", Icons.border_color),
    new DrawerItem("Share", Icons.share),
    new DrawerItem("Bulk Order", Icons.assignment),
    new DrawerItem("Sign Out", Icons.exit_to_app)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  SharedPreferences prefs;
  String userId,_name,_email,_mobile;
  int count =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();
    total();
    _selectedDrawerIndex=widget.title;

  }

  total() async {
    var cartitem =  await DBProvider.db.getCount();
    setState(()  {
      count =  cartitem;
    });
  }



  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);
      _name = prefs.getString(UserPreferences.USER_NAME);
      _email = prefs.getString(UserPreferences.USER_EMAIL);
      _mobile = prefs.getString(UserPreferences.USER_MOBILE);
      print(
          'userID' + userId + " : " + _name + " : " + _email + " : " + _mobile+" : "+'${widget.title}'
      );
    });
  }

  _getDrawerItemWidget(int pos) {

    switch (pos) {
      case 0:
        total();
        return new AllCategoriesFragment();
      /*case 1:
        return new AllCategoriesFragment();*/
      case 1:
        return new OrderFragment();
      case 2:
        return new ReferEarn();
    case 3:
        return new OrderForm();
        case 4:
        return new Logout();
      default:
        return new Text("Error");
    }

  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {

      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));

    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        //title: new Text('ShudhH2O)'),
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: <Widget>[

          Padding(
            padding: EdgeInsets.all(10.0),
            child: InkResponse(
              onTap: ()
                 => launch("tel://9713172282"),
            //    Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));

              child: Icon(Icons.call),
            ),
          ),

          Center
            (child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: InkResponse(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
                  },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              Positioned(

                    child: Container(
                      child: Text('${count}'),
                     // child: Text((DBP.length > 0) ? model.cartListing.length.toString() : "",textAlign: TextAlign.center,style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                    ),


              ),
            ],
          ),
          ),

        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                currentAccountPicture:
                new Center(

                  child: new Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (BuildContext context) =>  ProfileEdit()));
                          },
                          child:new Container(
                            width: 60.0,
                            height: 60.0,

                            decoration: new BoxDecoration(

                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,

                                  image: new AssetImage('images/man.png'),

                                )
                            ),

                          ),

                        ),
                      ] ),
                ),
                accountName: new Text('${_name}'),
                accountEmail :new Text('${_email}')
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
