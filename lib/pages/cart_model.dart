import 'package:crousgo/pages/item.dart';

class CartModel {
  final List<Item> _cart = [];

  List<Item> get cart => _cart;

  void addItem(Item item) {
  bool itemExists = cart.any((i) => i.id == item.id);

  if (itemExists) {
    var existingItem = cart.firstWhere((i) => i.id == item.id);
    existingItem.quantity += 1;
    print('This will be logged to the console in the browser.');
  } else {
    cart.add(item);
  }

}


  void removeFromCart(Item item) {
    _cart.remove(item);
  }

  bool isInCart(Item item) {
    return _cart.contains(item);
  }
}

final cartModel = CartModel();
