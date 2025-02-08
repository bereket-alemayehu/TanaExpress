import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/firebase_model/ordered_item.dart';


final orderedItemsProvider = StreamProvider<List<CartItem>>(
  (ref) => FirebaseOperations().getOrderedItems(),
);
