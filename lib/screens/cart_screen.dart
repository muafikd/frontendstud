import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: _buildCartItems(),
    );
  }

  Widget _buildCartItems() {
    // Replace this with actual data fetching logic
    List<CartItem> cartItems = [
      CartItem(productName: 'Product 1', quantity: 2, productPrice: 100.0, totalPrice: 200.0),
      CartItem(productName: 'Product 2', quantity: 1, productPrice: 150.0, totalPrice: 150.0),
    ];

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        CartItem item = cartItems[index];
        return ListTile(
          leading: Text(
            item.productName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          title: Text(
            '${item.totalPrice} ₽',
            style: const TextStyle(
              color: Color(0xFFB8860B),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class CartItem {
  final String productName;
  final int quantity;
  final double productPrice;
  final double totalPrice;

  CartItem({
    required this.productName,
    required this.quantity,
    required this.productPrice,
    required this.totalPrice,
  });
} 