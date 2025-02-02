import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

class FirebaseOperations {
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('ordered_items');

  // Fetch all ordered items (for the cart list)
  Stream<List<CartItem>> getOrderedItems() {
    return orderCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
    });
  }

  Future<void> addOrder(CartItem item) async {
    DocumentSnapshot existingOrder = await orderCollection.doc(item.id).get();

    if (existingOrder.exists) {
      int newQty = (existingOrder['qty'] ?? 0) + item.qty;
      await orderCollection.doc(item.id).update({'qty': newQty});
    } else {
      // Store all attributes initially
      await orderCollection.doc(item.id).set(item.toFirestore());
    }
  }

  // Update order quantity while keeping other attributes unchanged
  Future<void> updateOrderQty(String id, int newQty) async {
    DocumentSnapshot existingOrder = await orderCollection.doc(id).get();

    if (existingOrder.exists) {
      Map<String, dynamic> existingData =
          existingOrder.data() as Map<String, dynamic>;

      // Update only the qty field while keeping other attributes unchanged
      existingData['qty'] = newQty;

      await orderCollection.doc(id).update(existingData);
    }
  }

  // Delete an order from Firestore
  Future<void> deleteOrder(String id) async {
    await orderCollection.doc(id).delete();
  }
}
