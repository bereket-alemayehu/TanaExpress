import 'package:flutter/material.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/firebase_model/ordered_item.dart';
import 'package:tana_web_commerce/screens/order_now.dart'; // Import the new file

class OrderedItem extends StatefulWidget {
  const OrderedItem({
    super.key,
  });

  @override
  State<OrderedItem> createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  final FirebaseOperations firebaseOperations = FirebaseOperations();

  Future<void> _showOrderNowSheet(CartItem item) async {
    final qty = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return OrderNowSheet(
          item: item,
          isEditing: true,
        );
      },
    );

    if (qty != null) {
      firebaseOperations.updateOrderQty(item.id, qty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Your Order', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: firebaseOperations.getOrderedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Your order is empty.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          List<CartItem> cartItems = snapshot.data!;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                    image: item.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(item
                                .image), // Ensure the URL is correct and not empty
                            fit: BoxFit.cover,
                          )
                        : null, // If no image, avoid empty image container
                  ),

                  child: item.image.isEmpty
                      ? const Icon(Icons.image_not_supported,
                          color: Colors.grey) // Default icon if no image
                      : null, // Show image if URL is provided
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Price: ${item.price} Birr',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Qty: ${item.qty}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _showOrderNowSheet(item),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        firebaseOperations.deleteOrder(item.id);
                      },
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                  ],
                ),
              );
//
            },
          );
        },
      ),
    );
  }
}
