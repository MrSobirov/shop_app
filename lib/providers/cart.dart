import 'package:flutter/cupertino.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
});
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items{
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title)
  {
    if(_items.containsKey(productId)){
      _items.update(productId, (existingCart) => CartItem(
          id: existingCart.id,
          title: existingCart.title,
          quantity: existingCart.quantity +1,
          price: existingCart.price));
    }
    else {
      _items.putIfAbsent(productId, () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId].quantity>1)
      {
        _items.update(productId, (existingItem) =>
        CartItem(
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity -1,
            price: existingItem.price)
        );
      }
    else {
        _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear()
  {
    _items = { };
    notifyListeners();
  }
}
