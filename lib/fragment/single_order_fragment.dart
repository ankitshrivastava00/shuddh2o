import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuddh2o/common/UserPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shuddh2o/model/single_order_history_model.dart';

class SingleOrderFragment extends StatefulWidget {
  String productid,totalamount,discountamount,orderid;
  SingleOrderFragment(this.totalamount,this.discountamount,this.productid,this.orderid);
  @override
  _SingleOrderFragmentState createState() => new _SingleOrderFragmentState();
}

class _SingleOrderFragmentState extends State<SingleOrderFragment> {
  List<SingleOrderHistoryModel> list = List();
  var isLoading = false;
  String userId;
    _fetchData(userId) async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.post("http://sheltered-woodland-33544.herokuapp.com/orderhistory",body:{"id":widget.productid}
    );
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new SingleOrderHistoryModel.fromJson(data))
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
        appBar: AppBar(
          title: Text('View Full Order'),
          backgroundColor: Colors.lightBlue,
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :
        Column(
            children: [
          Expanded(child:
          ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  new  Container(
                    margin: EdgeInsets.all(5.0),
                    child:Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[100],
                                  width: 2.0
                              ),
                              top: BorderSide(
                                  color: Colors.grey[100],
                                  width: 2.0
                              ),
                            )
                        ),
                        height: 100.0,
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5.0
                                    )
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)
                                  ),
                                  image: DecorationImage(image: new AssetImage(
                                      'images/productimage.png'))
                              ),
                            ),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0,left: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text("ShudhH2O",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text("Price : ${list[index].price}"),
                                      SizedBox(height: 5.0,),
                                      Text("Category : ${list[index].category} Litre"),
                                      SizedBox(height: 5.0,),
                                      Text("Quantity : ${list[index].Quentity}"),

                                    ],
                                  ),
                                )
                            )
                          ],
                        ),

                      ),
                    ),
                  );
                }
              ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child:Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      ),
                      top: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      ),
                    )
                ),
                height: 80.0,
                child: Row(
                  children: <Widget>[

                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0,left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text("Order Id: ${widget.orderid}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                                  ),

                                ],
                              ),
                              SizedBox(height: 5.0,),
                              Text("Total Amount : Rs. ${widget.totalamount}"),
                              SizedBox(height: 5.0,),
                              Text("Discount Price : Rs. ${widget.discountamount}"),

                            ],
                          ),
                        )
                    )

                  ],
                ),

              ),
            ),
          ),

            ],
      ),
    );
  }
}
