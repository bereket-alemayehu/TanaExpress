import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tana_web_commerce/models/cart_item.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key, required this.item});
  final CartItem item;

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  late double _selectedPrice;
  late String _selectedType;

  final List<double> _priceOptions = [
    1000.0,
    2500.0,
    3000.0,
    2750.0,
    1570.0,
    4000.0,
    6000.0
  ];
  final List<String> _typeOptions = ['Cultural', 'Modern'];

  @override
  void initState() {
    super.initState();
    _selectedPrice = widget.item.price;
    _selectedType = widget.item.type;
    if (widget.item.image.isNotEmpty) {
      _image = File(widget.item.image);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final editedItem = CartItem(
        id: widget.item.id,
        type: _selectedType,
        price: _selectedPrice,
        image: _image?.path ?? '',
      );
      Navigator.of(context).pop(editedItem);
    }
  }

  void _reset() {
    setState(() {
      _image = null;
      _selectedPrice = widget.item.price;
      _selectedType = widget.item.type;
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
        title: const Text('Edit Item'),
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
                  onTap: () => _pickImage(ImageSource.gallery),
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
                      _selectedType = newValue!;
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
                      _selectedPrice = newValue!;
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
                        'Save',
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
}
