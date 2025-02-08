import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderedItemCountNotifier extends StateNotifier<int> {
  OrderedItemCountNotifier() : super(0);

  void updateOrderedItemCount(int count) {
    state = count;
  }
}

final orderedItemCountProvider =
    StateNotifierProvider<OrderedItemCountNotifier, int>(
  (ref) {
    return OrderedItemCountNotifier();
  },
);
