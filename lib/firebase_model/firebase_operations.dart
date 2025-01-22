import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

class FirebaseOperations {
  final CollectionReference clothCollection =
      FirebaseFirestore.instance.collection('cloths');

  Future<void> addToCart(CartItem item) async {
    await clothCollection.doc(item.id).set({
      'id': item.id,
      'type': item.type,
      'price': item.price,
      'image': item.image,
    });
  }

  Future<List<CartItem>> getAllClothes() async {
    QuerySnapshot querySnapshot = await clothCollection.get();
    return querySnapshot.docs.map(
      (doc) {
        return CartItem(
          id: doc['id'],
          type: doc['type'],
          price: doc['price'],
          image: doc['image'],
        );
      },
    ).toList();
  }

  Future<void> updateCloth(String id, CartItem item) async {
    await clothCollection.doc(id).update({
      'type': item.type,
      'price': item.price,
      'image': item.image,
    });
  }

  Future<void> deleteCloth(String id) async {
    await clothCollection.doc(id).delete();
  }
}
