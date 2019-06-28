
class OrderModel {
  final String Id,Image,Title,price,category,discount;
  OrderModel({this.Id,this.Image,this.Title,this.price,this.category, this.discount});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return new OrderModel(
      Id: json['_id'].toString().trim(),
      Image: json['image'].toString().trim(),
      Title: json['name'].toString().trim(),
      price: json['price'].toString().trim(),
      category: json['category'].toString().trim(),
      discount: json['discount'].toString().trim(),

    );
  }
}