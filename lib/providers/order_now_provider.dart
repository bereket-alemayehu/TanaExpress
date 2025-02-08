import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

final qtyProvider = StateProvider.family<double, CartItem>(
  (ref, item) {
    return item.qty.toDouble();
  },
);
