import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(CartItem item) {
    state = [...state, item];
  }

  void removeFromCart(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
