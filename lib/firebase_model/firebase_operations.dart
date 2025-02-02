import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

class FirebaseOperations {
  final CollectionReference clothCollection =
      FirebaseFirestore.instance.collection('cloths');

  /// Get all clothes as a stream (real-time updates)
  Stream<List<CartItem>> getAllClothesStream() {
    return clothCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return CartItem.fromFirestore(doc);
      }).toList();
    });
  }

  /// Get clothes filtered by category as a stream
  Stream<List<CartItem>> getClothesByCategoryStream(String selectedCategory) {
    return getAllClothesStream().map((allItems) {
      return allItems.where((item) => item.type == selectedCategory).toList();
    });
  }
}
