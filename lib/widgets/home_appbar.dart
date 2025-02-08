import 'package:flutter/material.dart';
import 'package:tana_web_commerce/models/cart_item.dart';
import 'package:tana_web_commerce/providers/cart_provider.dart';
import 'package:tana_web_commerce/providers/orderedItem_provider.dart';
import 'package:tana_web_commerce/screens/cart_screen.dart';
import 'package:tana_web_commerce/screens/order_items.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppbar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  ConsumerState<HomeAppbar> createState() => _HomeAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends ConsumerState<HomeAppbar> {
  Future<void> _navigateToCartScreen(List<CartItem> cartList) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Cartscreen(),
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
    final cartList = ref.watch(cartProvider);

    return AppBar(
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
            ref.watch(orderedItemCountProvider).bitLength.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          showBadge: ref.watch(orderedItemCountProvider).bitLength > 0,
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          child: IconButton(
            onPressed: _navigateToOrderedScreen,
            icon: const Icon(Icons.local_shipping_outlined),
          ),
        ),
        badges.Badge(
          badgeContent: Text(
            ref.watch(cartProvider).length.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          showBadge: ref.watch(cartProvider).isNotEmpty,
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          child: IconButton(
            onPressed: () => _navigateToCartScreen(cartList),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ),
      ],
    );
  }
}
