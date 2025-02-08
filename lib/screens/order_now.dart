import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/providers/order_now_provider.dart';
import 'package:tana_web_commerce/screens/buy_now.dart';
import 'package:tana_web_commerce/firebase_model/ordered_item.dart';

class OrderNowSheet extends ConsumerStatefulWidget {
  final CartItem item;
  final bool isEditing;

  const OrderNowSheet({
    super.key,
    required this.item,
    this.isEditing = false,
  });

  @override
  ConsumerState<OrderNowSheet> createState() => _OrderNowSheetState();
}

class _OrderNowSheetState extends ConsumerState<OrderNowSheet> {
  final FirebaseOperations firebaseOperations = FirebaseOperations();

  @override
  Widget build(BuildContext context) {
    final qty = ref.watch(qtyProvider(widget.item));

    void increaseQty() {
      ref.read(qtyProvider(widget.item).notifier).state = qty + 1;
    }

    void decreaseQty() {
      if (qty > 1) {
        ref.read(qtyProvider(widget.item).notifier).state = qty - 1;
      }
    }

    void handleUpdate() {
      Navigator.pop(context, qty.toInt());
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 350,
      decoration: const BoxDecoration(
        color: Color.fromARGB(205, 216, 213, 213),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
          Text(
            widget.isEditing ? 'Update Order' : 'Order Now',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image.network(
                widget.item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.type,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${widget.item.price} Birr'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Qty: '),
              IconButton(
                onPressed: decreaseQty,
                icon: const Icon(Icons.remove),
              ),
              Text(
                '$qty',
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                onPressed: increaseQty,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: TextButton(
              onPressed: () async {
                if (widget.isEditing) {
                  handleUpdate();
                } else {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          BuyNowScreen(item: widget.item, qty: qty),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.isEditing ? 'Update' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
