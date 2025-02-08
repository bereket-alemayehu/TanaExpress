import 'package:flutter/material.dart';
import 'package:tana_web_commerce/firebase_model/firebase_operations.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/screens/detail_screen.dart';

class StreamBuilderList extends StatefulWidget {
  const StreamBuilderList({super.key, required this.selectedCategory});

  final String selectedCategory;

  @override
  State<StreamBuilderList> createState() => _StreamBuilderListState();
}

class _StreamBuilderListState extends State<StreamBuilderList> {
  final FirebaseOperations firebaseOperations = FirebaseOperations();
  Future<void> _navigateToDetailScreen(CartItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItem>>(
      stream: firebaseOperations
          .getClothesByCategoryStream(widget.selectedCategory),
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
        ); //
      },
    );
  }
}
