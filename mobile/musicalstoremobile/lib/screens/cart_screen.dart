import 'package:flutter/material.dart';
import 'package:musicalstoremobile/models/cart_item.dart';
import 'package:musicalstoremobile/services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _error;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _checkout() async {
    try {
      if (_cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Корзина пуста'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final orderData = await _cartService.checkout();
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/order-success',
        arguments: {
          'orderId': orderData['orderId'],
          'totalPrice': orderData['totalPrice'],
        },
      );
    } catch (e) {
      if (!mounted) return;
      String errorMessage = 'Ошибка при оформлении заказа';

      if (e.toString().contains('Необходима авторизация')) {
        errorMessage = 'Пожалуйста, войдите в систему';
        Navigator.pushReplacementNamed(context, '/login');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cartItems = await _cartService.getCartItems();
      setState(() {
        _cartItems = cartItems;
        _calculateTotal();
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки корзины';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateTotal() {
    _totalPrice = _cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice, // Используем totalPrice из модели
    );
  }

  Future<void> _updateQuantity(int cartItemId, bool increase) async {
    try {
      await _cartService.updateQuantity(cartItemId, increase);
      await _loadCart();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка обновления количества')),
      );
    }
  }

  Future<void> _removeItem(int cartItemId) async {
    // Изменен параметр на cartItemId
    try {
      await _cartService.removeFromCart(cartItemId);
      await _loadCart();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка удаления товара')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Корзина',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _cartItems.isEmpty
                  ? const Center(
                      child: Text('Корзина пуста'),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final item = _cartItems[index];
                              return Dismissible(
                                key: Key(item.cartItemId
                                    .toString()), // Используем cartItemId
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  _removeItem(item.cartItemId);
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            item.productName, // Используем product.imageUrl
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.album),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.productName, // Используем product.title
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.productName, // Используем product.artist
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '${item.totalPrice} тг', // Используем totalPrice
                                                style: const TextStyle(
                                                  color: Color(0xFFB8860B),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () => _updateQuantity(
                                                item.cartItemId,
                                                false,
                                              ),
                                            ),
                                            Text(
                                              item.quantity.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () => _updateQuantity(
                                                item.cartItemId,
                                                true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Итого:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_totalPrice.toStringAsFixed(2)} тг',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB8860B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _checkout,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB8860B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Оформить заказ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
