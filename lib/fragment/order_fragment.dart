import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:shuddh2o/fragment/single_order_fragment.dart';
import 'dart:convert';

import 'package:shuddh2o/model/order_history_model.dart';

class OrderFragment extends StatefulWidget {
  @override
  _OrderFragmentState createState() => new _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> {
  List<OrderHistoryModel> list = List();
  var isLoading = false;
String userId;
  _fetchData(userId) async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.post("https://sheltered-woodland-33544.herokuapp.com/order/vieworder",body:{"userid":'${userId}'}
    );
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new OrderHistoryModel.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
    }
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);

      _fetchData(userId);
    });
  }

    @override
  void initState() {
    // TODO: implement initState
      getSharedPreferences();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return
                new InkWell(
                  child: new Padding(
                      padding: new EdgeInsets.all(0.0),
                      child: new Container(
                        width: double.infinity,
                        child: new Card(
                          color: Colors.white,
                          child: new Container(
                              child: new ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => SingleOrderFragment('${list[index].total}','${list[index].discounttotal}','${list[index].Id}','${list[index].orderid}')));
                                },
                                leading: new Image.asset('images/hydroberry.png', fit: BoxFit.cover,
                                  height: 40.0,
                                  width: 40.0,),

                                subtitle: new Container(
                                  child: new Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: new Text('Totoal Amount : ${list[index].total}',
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Roboto',
                                        )),
                                  ),
                                  margin: EdgeInsets.all(5.0),
                                ),

                                title: new Text('Order Id : ${list[index].orderid}',
                                    textAlign: TextAlign.start,
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      )),
                );
            }));
  }
}
