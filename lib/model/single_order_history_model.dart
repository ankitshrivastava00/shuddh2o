
class SingleOrderHistoryModel {
  final String category,Quentity,price;
 // final double ;
  final String paymentid;
  SingleOrderHistoryModel({this.category,this.Quentity,this.paymentid,this.price});

  factory SingleOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return new SingleOrderHistoryModel(
      category: json['category'].toString().trim(),
      Quentity: json['Quentity'].toString().trim(),
      paymentid: json['paymentid'].toString().trim(),
      price: json['price'].toString().trim(),

    );
  }
}