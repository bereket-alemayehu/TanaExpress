import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/firebase_model/ordered_item.dart';
import 'package:tana_web_commerce/providers/order_items_provider.dart';
import 'package:tana_web_commerce/screens/order_now.dart';

class OrderedItem extends ConsumerWidget {
  const OrderedItem({super.key});

  Future<void> _showOrderNowSheet(
      BuildContext context, CartItem item, WidgetRef ref) async {
    final qty = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return OrderNowSheet(
            item: item,
            isEditing: true,
          );
        });

    if (qty != null) {
      FirebaseOperations().updateOrderQty(item.id, qty);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title:
              const Text('Your Order', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )),
      body: ref.watch(orderedItemsProvider).when(
            data: (cartItems) {
              if (cartItems.isEmpty) {
                return const Center(
                    child: Text(
                  'Your order is empty.',
                  style: TextStyle(fontSize: 18),
                ));
              }
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
                                    image: NetworkImage(item.image),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                        child: item.image.isEmpty
                            ? const Icon(Icons.image_not_supported,
                                color: Colors.grey)
                            : null),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text('Price: ${item.price} Birr',
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
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
                          onPressed: () =>
                              _showOrderNowSheet(context, item, ref),
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
                            FirebaseOperations().deleteOrder(item.id);
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
    );
  }
}
