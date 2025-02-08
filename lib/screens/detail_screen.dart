import 'package:flutter/material.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/providers/cart_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({
    super.key,
    required this.item,
  });
  final CartItem item;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.read(cartProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Detail of selected item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Center(
          child: Column(
            children: [
              Image.network(
                widget.item.image,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Description: ', // Bold part
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(169, 20, 18, 18),
                            ),
                          ),
                          TextSpan(
                            text: widget.item.detail, // Normal text
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Color.fromARGB(169, 20, 18, 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Type: ${widget.item.type}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Price: ${widget.item.price} Birr',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          cartNotifier.addToCart(
                            widget.item,
                          );
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(
                            color: Color.fromARGB(191, 0, 0, 0),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
