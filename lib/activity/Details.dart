import "package:flutter/material.dart";
import 'package:shuddh2o/DBUtils/DBProvider.dart';
import 'package:shuddh2o/activity/Cart.dart';
import 'package:shuddh2o/common/spinner_input.dart';
import 'package:shuddh2o/model/order_model.dart';

class Details extends StatefulWidget{

  static final String route = "Home-route";
  OrderModel detail;
  Details({this.detail});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsState();
  }
}

class DetailsState extends State<Details>{
  double spinner = 1;
  int count =0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PageController _controller;
  int active =0;
  int _n = 1;
  double total = 0;


  Widget buildDot(int index,int num){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(

            color: (num == index ) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle
        ),
      ),
    );
  }
  /*void add() {
    setState(() {
      _n++;
      total=_n* double.tryParse('${widget.detail.price}');
    });
  }
  void minus() {
    setState(() {
      if (_n != 0)
        _n--;
        total=_n * double.tryParse('${widget.detail.price}');

    });
  }*/
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    total=double.tryParse('${widget.detail.price}');
    cartCount();
  }


  cartCount() async {
    var cartitem =  await DBProvider.db.getCount();
    setState(()  {
      count =  cartitem;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("View Item"),
            actions: <Widget>[
              Center
                (child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkResponse(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Cart()));
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
          body: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.grey[300],
                        width: 1.0
                    )
                )
            ),
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 280.0,
                      padding: EdgeInsets.only(top: 10.0),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 200.0,
                            child: PageView(
                              controller: _controller,
                              onPageChanged: (index){
                                print(index);
                                setState(() {
                                  active = index;
                                });
                              },
                              children: <Widget>[
                                new Container(
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'images/productimage.png'),
                                    ),
                                  ),
                                ),
                                new Container(
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'images/productimage.png'),
                                    ),
                                  ),
                                ),
                                new Container(
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'images/productimage.png'),
                                    ),
                                  ),
                                ),
                                new Container(
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'images/productimage.png'),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                      //    SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildDot(active,0),
                              buildDot(active,1),
                              buildDot(active,2),
                              buildDot(active,3)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[300],height: 1.0,),
/*
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(height: 30.0,),
                      // default spinner
                    ],
                  ),
                ),
*/
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[

                      new Expanded(
                        child:Container(
                          child:Text(widget.detail.Title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),),
                        //  height: 40.0,
                          margin: EdgeInsets.all(5.0),

                        ),
                      ),
                      new Expanded(

                        child:Container(

                          child:Text("Litre : "+widget.detail.category,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),),
                          margin: EdgeInsets.all(5.0),

                          //   margin: EdgeInsets.only(left:8.0),
                        ),
                      ),
                    ]), new Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[

                      new Expanded(
                        child:Container(
                          child: Text("Discount : "+widget.detail.discount +"%",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),

                          //  height: 40.0,
                          margin: EdgeInsets.all(5.0),
                        ),
                      ),
                      new Expanded(

                        child:Container(

                          child: Text("Price : "+widget.detail.price,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                          margin: EdgeInsets.all(5.0),


                          //   margin: EdgeInsets.only(left:8.0),
                        ),
                      ),
                    ]),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[

                      new Expanded(
                        child:Container(
                          child: Text("Quantity",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),

                          //  height: 40.0,
                          margin: EdgeInsets.all(5.0),

                        ),
                      ),
                      new Expanded(

                        child:Container(

                          child: SpinnerInput(
                            spinnerValue: spinner,
                  minValue: 1,
                  maxValue: 200,
                            onChange: (newValue) {
                              setState(() {
                                spinner = newValue;
                                total=double.tryParse('${widget.detail.price}') * spinner;
                              });
                            },
                          ),
                          margin: EdgeInsets.all(5.0),


                          //   margin: EdgeInsets.only(left:8.0),
                        ),
                      ),
                    ]),


              ],
            ),
          ),
          bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 18.0),
              height: 60.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Colors.grey[300],width: 1.0)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60.0,
                          child: Text("Total Amount",style: TextStyle(fontSize: 12.0,color: Colors.grey),),
                        ),
                        Text("Rs. ${total.toString()}",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                /*  ScopedModelDescendant<AppModel>(
                    builder: (context,child,model){*/
                       RaisedButton(
                        color: Colors.deepOrange,
                        onPressed: (){
                          DBProvider.db.newClient('${widget.detail.Id}','${widget.detail.Title}','${spinner}','${total}','${widget.detail.category}');
                          Future.delayed(const Duration(milliseconds: 2000), () {
                            cartCount();

                          });

                        },
                        child: Text("ADD TO CART",style: TextStyle(color: Colors.white),),
                      ),
          //          },
            //      )
                ],
              )
          ),
        ),
    );
  }

}
