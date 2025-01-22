import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/firebase_model/firebase_operations.dart';
import 'package:tana_web_commerce/screens/edit_item_screen.dart';

class Cartscreen extends StatefulWidget {
  const Cartscreen({
    super.key,
    required this.cartList,
  });
  final List<CartItem> cartList;

  @override
  State<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  final FirebaseOperations _firebaseOps = FirebaseOperations();

  Future<void> _editItem(CartItem item) async {
    final editedItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditItemScreen(item: item),
      ),
    );
    if (editedItem != null && editedItem is CartItem) {
      setState(
        () {
          // Find the index of the item to be edited
          int index = widget.cartList.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            // Update the item at the found index
            widget.cartList[index] = editedItem;
          }
        },
      );
      await _firebaseOps.updateCloth(item.id, editedItem);
    }
  }

  Future<void> _deleteItem(CartItem item) async {
    setState(() {
      // Remove the specific item from the cart list
      widget.cartList.removeWhere((i) => i.id == item.id);
    });
    await _firebaseOps.deleteCloth(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Your List', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: widget.cartList.isEmpty
            ? const Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18),
              )
            : ListView.builder(
                itemCount: widget.cartList.length,
                itemBuilder: (context, index) {
                  final item = widget.cartList[index];
                  return ListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        shape: BoxShape.rectangle,
                        image: item.image.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(File(item.image)),
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
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _editItem(item),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _deleteItem(item),
                          icon: const Icon(Icons.delete_forever_outlined),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
