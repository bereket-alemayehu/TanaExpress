import 'package:flutter/material.dart';
import 'package:tana_web_commerce/firebase_model/ordered_item.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

class BuyNowScreen extends StatefulWidget {
  final CartItem item;
  final double qty;

  const BuyNowScreen({
    super.key,
    required this.item,
    required this.qty,
  });

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  String? _selectedPaymentMethod = 'Credit Card'; // Default payment method

  double get subtotal => widget.qty * widget.item.price;
  double get totalPrice => subtotal + 50; // Add shipping fee (for demo)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Now'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Address Section (Updated to InputField)
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Name
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              // Country
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              // Postal Code
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              // Phone Number
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),

              // Street
              TextField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 26),

              // Item Details Section
              const Text(
                "Item's Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                      Text('Qty: ${widget.qty}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

             
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'Credit Card',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  const Text('Credit Card'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'PayPal',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  const Text('PayPal'),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Section
              const Text(
                'Summary',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ${widget.item.price} Birr',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                'Subtotal: $subtotal Birr',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                'Shipping Fee: 50 Birr',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const Divider(),
              Row(
                children: [
                  Text(
                    'Total Price: $totalPrice Birr',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        widget.item.qty = widget.qty;

                        FirebaseOperations().addOrder(widget.item);

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Icon(Icons.done_all_outlined,
                                color: Colors.green),
                            content: const Text(
                              'Your order has been placed successfully!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'OK',
                            
                                ),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Error',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            content: Text(
                              'There was an error placing your order: $e',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
