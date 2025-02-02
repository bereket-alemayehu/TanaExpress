import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tana_web_commerce/firebase_model/firebase_operations.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/screens/cart_screen.dart';
import 'package:tana_web_commerce/screens/detail_screen.dart';
import 'package:tana_web_commerce/screens/order_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CartItem> cartList = [];
  final FirebaseOperations firebaseOperations = FirebaseOperations();
  String selectedCategory = 'Cultural';

  int orderedItemCount = 0;
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrderedItemCount();
  }

  void _fetchOrderedItemCount() {
    FirebaseFirestore.instance
        .collection('ordered_items')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        orderedItemCount = snapshot.docs.length;
      });
    });
  }

  Future<void> _navigateToCartScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Cartscreen(cartList: cartList),
      ),
    );
  }

  void _addToCart(CartItem item) {
    setState(() {
      cartList.add(item);
      cartItemCount = cartList.length;
    });
  }

  Future<void> _navigateToDetailScreen(CartItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item, addToCart: _addToCart),
      ),
    );
  }

  Future<void> _navigateToOrderedScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OrderedItem(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: const Text(
          "TanaExpress",
          style: TextStyle(
              color: Color.fromARGB(255, 69, 10, 171),
              fontWeight: FontWeight.bold),
        ),
        actions: [
          badges.Badge(
            badgeContent: Text(
              orderedItemCount.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            showBadge: orderedItemCount > 0,
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            child: IconButton(
              onPressed: _navigateToOrderedScreen,
              icon: const Icon(Icons.local_shipping_outlined),
            ),
          ),
          badges.Badge(
            badgeContent: Text(
              cartItemCount.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            showBadge: cartItemCount > 0,
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            child: IconButton(
              onPressed: _navigateToCartScreen,
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: firebaseOperations.getClothesByCategoryStream(selectedCategory),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No items available in the database.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          List<CartItem> filteredData = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true,
            itemCount: filteredData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final item = filteredData[index];
              return GestureDetector(
                onTap: () => _navigateToDetailScreen(item),
                child: Card(
                  elevation: 4,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          item.image,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: ${item.price} Birr',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
