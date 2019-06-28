
class OrderHistoryModel {
  final String Id,paymentid,userid,discounttotal,total,orderid;
  OrderHistoryModel({this.Id,this.paymentid,this.userid,this.discounttotal,this.total,this.orderid});

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return new OrderHistoryModel(
      Id: json['_id'].toString().trim(),
      paymentid: json['paymentid'].toString().trim(),
      userid: json['userid'].toString().trim(),
      discounttotal: json['discounttotal'].toString().trim(),
      orderid: json['orderid'].toString().trim(),
      total: json['total'].toString().trim(),

    );
  }
}