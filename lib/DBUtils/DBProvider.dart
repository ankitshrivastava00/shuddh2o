import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shuddh2o/DBUtils/ClientModel.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;
  List<Client> _cart = [];


  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "shudhh2o.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Cart ("
              "id INTEGER PRIMARY KEY,"
              "product_id TEXT,"
              "product_name TEXT,"
              "quantity TEXT,"
              "price TEXT,"
              "category TEXT"
              ")");
        });
  }



  newClient(String pro_id,String product_name,String product_quantity, product_price,String product_category) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM Cart WHERE product_id = '${pro_id}'"));
    print('COUNTING DATA ${count}');
    if(count == 1){
      updateClient(pro_id,product_name,product_quantity,product_price,product_category);
    } else {
      //get the biggest id in the table
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Cart");
      int id = table.first["id"];
      //insert to the table using the new id
      var raw = await db.rawInsert(
          "INSERT Into Cart (id,product_id,product_name,quantity,price,category)"
              " VALUES (?,?,?,?,?,?)",
          [
            id,
            pro_id,
            product_name,
            product_quantity,
            product_price,
            product_category
          ]);
      Fluttertoast.showToast(msg: "Add In Your Cart", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);

      return raw;

    }
    return null;
  }



  getCount() async {
    var db = await database;
    return Sqflite. firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Cart'));
  }


  updateClient(String pro_id,String product_name,String product_quantity, product_price,String product_category) async {
    final db = await database;
    var res = /*await db.update("Cart", quantity
        where: "product_id = ?", whereArgs: [product_id]);*/
    db.rawUpdate("UPDATE Cart SET  quantity = '${product_quantity}',price = '${product_price}' WHERE product_id = '${pro_id}'");
    Fluttertoast.showToast(msg: "Update In Your Cart", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);

    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Cart", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }


  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Cart");
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];

    return list;
  }
  Future  getAllClientsCard() async {
    final db = await database;
    var res = await db.query("Cart");
    //   List<Client> list =
//    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    print('casrdawf ${res.toList()}');

    return res.toList();
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Cart", where: "id = ?", whereArgs: [id]);
  }
  Future calculateTotal() async {
    final db = await database;
    var result = await db.rawQuery("SELECT SUM(price) as Total FROM Cart");
    print('sdfasdfasdf ${result.toList()}');
    return result.toList();
  }

  // Cart Listing
  List<Client> get cartListing => _cart;

  deleteAll() async {
    final db = await database;
    db.rawDelete("DELETE FROM Cart");
  }
}