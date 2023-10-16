import 'item.dart';

class CartModel {
  final List<Item> _cart = [];

  List<Item> get cart => _cart;

  void addItem(Item item) {
    _cart.add(item);
  }

  void removeFromCart(Item item) {
    _cart.remove(item);
  }

  bool isInCart(Item item) {
    return _cart.contains(item);
  }
}

final cartModel = CartModel();
