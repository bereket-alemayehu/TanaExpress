import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderedItemCountNotifier extends StateNotifier<int> {
  // is the riverpod class used to manage state.
  OrderedItemCountNotifier() : super(0); // here the count is 0 at first.

  void updateOrderedItemCount(int count) {
    state = count;
  }
}

final orderedItemCountProvider =// this is a special type of provider in riverpod this lets you to access this widget from any widget in the app.
    StateNotifierProvider<OrderedItemCountNotifier, int>(
  (ref) {
    return OrderedItemCountNotifier();
  },
);
