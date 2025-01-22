import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/firebase_model/firebase_operations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.addToCart});
  final Function(CartItem) addToCart;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  double? _selectedPrice;
  String? _selectedType;
  final FirebaseOperations _firebaseOps = FirebaseOperations();
  final Uuid uuid = const Uuid();

  final List<double> _priceOptions = [
    1000.0,
    2500.0,
    3000.0,
    2750.0,
    1570.0,
    4000.0,
    6000.0,
  ];
  final List<String> _typeOptions = ['Cultural', 'Modern'];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String imageUrl = '';
      if (_image != null) {
        imageUrl = await _uploadImageToFirebase(_image!);
      }
      final newItem = CartItem(
        id: uuid.v4(),
        type: _selectedType!,
        price: _selectedPrice!,
        image: imageUrl,
      );

      widget.addToCart(newItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Item added to cart successfully',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.greenAccent,
          ),
        );

        Navigator.of(context).pop();
      }

      try {
        await _firebaseOps.addToCart(newItem);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding item to database: $e'),
            ),
          );
        }
      }
    }
  }

  void _reset() {
    setState(() {
      _image = null;
      _selectedPrice = null;
      _selectedType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 215, 217),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text('Add Item'),
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: const Color.fromARGB(255, 206, 215, 217),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showPicker(context),
                  child: _image == null
                      ? Container(
                          height: 100,
                          width: 100,
                          color: Colors.white,
                          child: const Icon(Icons.add_a_photo),
                        )
                      : Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                        ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Select type',
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  value: _selectedType,
                  items: _typeOptions.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Select Price',
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  value: _selectedPrice,
                  items: _priceOptions.map((price) {
                    return DropdownMenuItem(
                      value: price,
                      child: Text('${price.toString()} birr'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPrice = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Order now',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
