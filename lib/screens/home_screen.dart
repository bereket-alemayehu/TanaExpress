import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/screens/cart_screen.dart';
import 'package:tana_web_commerce/screens/add_item_screen.dart';
import 'package:tana_web_commerce/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CartItem> cartList = [];
  String selectedCategory = 'Cultural';
  final CollectionReference clothCollection =
      FirebaseFirestore.instance.collection('cloths');

  Future<void> _navigateToAddItemScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddItemScreen(addToCart: _addToCart),
      ),
    );
  }

  Future<void> _navigateToCartScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Cartscreen(cartList: cartList),
      ),
    );
  }

  Future<void> _navigateToDetailScreen(CartItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item, addToCart: _addToCart),
      ),
    );
  }

  void _addToCart(CartItem item) {
    setState(() {
      cartList.add(item);
    });
  }

  Future<void> _deleteItem(CartItem item) async {
    setState(() {
      cartList.removeWhere((i) => i.id == item.id);
    });
    await FirebaseFirestore.instance.collection('cloths').doc(item.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tana Ecommerce'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _navigateToCartScreen,
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: clothCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No items available in the database.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                List<CartItem> allItems = snapshot.data!.docs.map((doc) {
                  return CartItem(
                    id: doc.id,
                    type: doc['type'],
                    price: doc['price'],
                    image: doc['image'],
                  );
                }).toList();

                List<CartItem> filteredData = allItems
                    .where((item) => item.type == selectedCategory)
                    .toList();

                if (filteredData.isEmpty) {
                  return Center(
                    child: Text(
                      'No items available for $selectedCategory cloths.',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: filteredData.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetailScreen(item),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              item.image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.type,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('${item.price} Birr'),
                            IconButton(
                              onPressed: () => _deleteItem(item),
                              icon: const Icon(Icons.delete_forever_outlined),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItemScreen,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Cultural Cloths',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Modern Cloths',
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedCategory = index == 0 ? 'Cultural' : 'Modern';
          });
        },
        currentIndex: selectedCategory == 'Cultural' ? 0 : 1,
      ),
    );
  }
}
