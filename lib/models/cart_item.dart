// import 'package:uuid/uuid.dart';

// var uuid = Uuid();

class CartItem {
  final String id;
  final String type;
  final double price;
  final String image;

  CartItem({
    required this.id,
    required this.type,
    required this.price,
    required this.image,
  });
}


/// import 'package:uuid/uuid.dart';

// var uuid = const Uuid();

// class CartItem {
//   final String id;
//   final String type;
//   final double price;
//   final String image;

//   CartItem({
//     required this.type,
//     required this.price,
//     required this.image,
//   }) : id = uuid.v4(); // Automatically generate a UUID for `id`
// }
///