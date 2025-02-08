import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tana_web_commerce/firebase_model/firebase_operations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tana_web_commerce/providers/orderedItem_provider.dart';
import 'package:tana_web_commerce/widgets/home_appbar.dart';
import 'package:tana_web_commerce/widgets/stream_builder_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String selectedCategory = 'Cultural';
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
      ref
          .read(orderedItemCountProvider.notifier)
          .updateOrderedItemCount(snapshot.docs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: StreamBuilderList(selectedCategory: selectedCategory),
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
