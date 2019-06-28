import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
class Client {
  int id;
  String product_id;
  String product_name;
  String quantity;
  String price;
  String category;

  Client({
    this.id,
    this.product_id,
    this.product_name,
    this.quantity,
    this.price,
    this.category,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    product_id: json["product_id"],
    product_name: json["product_name"],
    quantity: json["quantity"],
    price: json["price"],
    category: json["category"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "product_id": product_id,
    "product_name": product_name,
    "quantity": quantity,
    "price": price,
    "category": category,
  };
}