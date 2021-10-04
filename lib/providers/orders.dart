import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/models/http_exception.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
});
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this._orders, this.userId, this.authToken);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shopapp-50487-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if(extractedData == null)
        {
          return;
        }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['ordered_products'] as List<dynamic>).map(
                  (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price'],
                  )
          ).toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch(error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final url = 'https://shopapp-50487-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final time = DateTime.now();
    try {
      final response = await  http.post(url, body: json.encode({
        'amount': total,
        'dateTime': time.toIso8601String(),
        'ordered_products': cartProducts.map((cartP) => {
          'id': cartP.id,
          'title': cartP.title,
          'quantity': cartP.quantity,
          'price': cartP.price,
        }).toList(),
      }),
      );
      final newOrder = OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: time,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch(error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeOrder(String orderID) async
  {
    final url = 'https://shopapp-50487-default-rtdb.firebaseio.com/orders/$userId/$orderID.json?auth=$authToken';
    final existingProductIndex = _orders.indexWhere((prod) => prod.id == orderID);
    var existingProduct = _orders[existingProductIndex];
    _orders.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >= 400){
      _orders.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}

