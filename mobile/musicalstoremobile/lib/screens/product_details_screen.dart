import 'package:flutter/material.dart';
import 'package:musicalstoremobile/models/product.dart';
import 'package:musicalstoremobile/services/cart_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartService _cartService = CartService();
  int _quantity = 1;
  bool _isAddingToCart = false;

  

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      await _cartService.addToCart(widget.product.productId!, _quantity);
      print('Product added to cart successfully'); // Для отладки

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Товар добавлен в корзину'),
          backgroundColor: Color(0xFFB8860B),
        ),
      );
      
      // Обновляем корзину в CartScreen перед возвратом
      // if (mounted) {
      //   Navigator.pop(context);
      //   Navigator.pushReplacementNamed(context, '/cart');
      // }
    } catch (e) {
      print('Error adding to cart: $e'); // Для отладки
      if (!mounted) return;
      String errorMessage = 'Ошибка при добавлении в корзину';

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
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  void _animateToCart({required double startX, required double startY}) {
    // Создаем оверлей для анимации
    final overlay = OverlayEntry(
      builder: (context) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOut,
          left: startX,
          top: startY,
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFFB8860B),
            child: Icon(
              Icons.shopping_cart,
              size: 14,
              color: Colors.white,
            ),
          ),
        );
      },
    );

    // Добавляем оверлей
    Overlay.of(context).insert(overlay);

    // Удаляем оверлей после анимации
    Future.delayed(const Duration(milliseconds: 750), () {
      overlay.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.productId}',
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.album,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.artist,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8860B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.product.genre,
                          style: const TextStyle(
                            color: Color(0xFFB8860B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.product.releaseYear}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        '${widget.product.price} тг',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB8860B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed:
                                  _quantity < widget.product.stockQuantity
                                      ? () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        }
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isAddingToCart ? null : () => _addToCart(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isAddingToCart
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Добавить в корзину',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
