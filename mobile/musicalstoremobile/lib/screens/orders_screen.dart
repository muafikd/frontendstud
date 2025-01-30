import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musicalstoremobile/models/order.dart';
import 'package:musicalstoremobile/services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final orders = await _orderService.getOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (e.toString().contains('Необходима авторизация')) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadOrders,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  )
                : _orders.isEmpty
                    ? const Center(
                        child: Text('У вас пока нет заказов'),
                      )
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Заказ #${order.orderId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Статус: ${order.orderStatus}',
                                    style: TextStyle(
                                      color: _getStatusColor(order.orderStatus),
                                    ),
                                  ),
                                  Text(
                                    'Дата: ${DateFormat('dd.MM.yyyy HH:mm').format(order.placedAt)}',
                                  ),
                                  Text(
                                    'Сумма: ${order.totalPrice.toStringAsFixed(2)} тг',
                                    style: const TextStyle(
                                      color: Color(0xFFB8860B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}