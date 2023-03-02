import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/order_item.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartsItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-update-11529-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(json.decode(response.body),);
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderData['Amount'],
            dateTime: DateTime.parse(orderData['dateTime'],),
            products: (orderData['products'])
                .map((item) => CartsItem(
                    id: item.id,
                    price: item.price,
                    quantity: item.quantity,
                    title: item.title,
            ),
            ).toList(),
        ),
      );
    });
    _orders=loadedOrders;
    notifyListeners();
  }

  void addOrders(List<CartsItem> cartProducts, double total) async {
    const url =
        'https://flutter-update-11529-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'price': cp.price,
                      'quantity': cp.quantity,
                      'title': cp.title,
                    })
                .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts),
    );
    notifyListeners();
  }
}
