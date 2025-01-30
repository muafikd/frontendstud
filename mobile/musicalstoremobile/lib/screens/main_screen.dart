import 'package:flutter/material.dart';
import 'package:musicalstoremobile/screens/catalog_screen.dart';
import 'package:musicalstoremobile/screens/cart_screen.dart';
import 'package:musicalstoremobile/screens/orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = const [
    CatalogScreen(),
    CartScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Заказы',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFB8860B),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}