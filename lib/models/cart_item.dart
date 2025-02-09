import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String type;
  double price;
  final String image;
  double qty;
  final String detail;

  CartItem({
    required this.type,
    required this.price,
    required this.image,
    required this.qty,
    required this.detail,
    required this.id,
  });

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return CartItem(
      id: doc.id,
      type: data?['type'] as String? ?? 'Unknown',
      price: (data?['price'] as num?)?.toDouble() ?? 0.0,
      image: data?['image'] as String? ?? '',
      detail: data?['detail'] as String? ?? 'No details available',
      qty: (data?['qty'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'image': image,
      'price': price,
      'qty': qty,
      'detail': detail,
    };
  }
}
