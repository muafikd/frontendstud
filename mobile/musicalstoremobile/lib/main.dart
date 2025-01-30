import 'package:flutter/material.dart';
import 'package:musicalstoremobile/screens/catalog_screen.dart';
import 'package:musicalstoremobile/screens/cart_screen.dart';
import 'package:musicalstoremobile/screens/orders_screen.dart';
import 'package:musicalstoremobile/screens/login_screen.dart';
import 'package:musicalstoremobile/screens/order_success_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musical Store',
      theme: ThemeData(
        primaryColor: const Color(0xFFB8860B),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/catalog': (context) => const MainScreen(),
        '/cart': (context) => const CartScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/order-success': (context) => const OrderSuccessScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = [
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

void main() {
  runApp(const MyApp());
}