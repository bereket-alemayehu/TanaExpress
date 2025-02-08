import 'package:flutter/material.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/providers/cart_provider.dart';
import 'package:tana_web_commerce/screens/order_now.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cartscreen extends ConsumerStatefulWidget {
  const Cartscreen({
    super.key,
  });

  @override
  ConsumerState<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends ConsumerState<Cartscreen> {
  Future<void> _showOrderNowSheet(CartItem item) async {
    final qty = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return OrderNowSheet(item: item); 
      },
    );

    if (qty != null) {
    
      // print('User selected quantity: $qty');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartList = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Your List', style: TextStyle(color: Colors.white)),
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
      body: Center(
        child: cartList.isEmpty
            ? const Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18),
              )
            : ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  final item = cartList[index];
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
                            : null,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          'Price: ${item.price} Birr',
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () =>
                              _showOrderNowSheet(item), // Show the bottom sheet
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Buy now',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .removeFromCart(item.id);
                            },
                            child: const Text('Cancel')),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
