import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicalstoremobile/models/order.dart';

class OrderService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<List<Order>> getOrders() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-orders'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body) as List;
        return jsonData
            .map((item) => Order.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Необходима авторизация');
      }
      throw Exception('Ошибка при загрузке заказов');
    } catch (e) {
      print('Error in getOrders: $e');
      throw Exception(e.toString());
    }
  }

  Future<OrderDetails> getOrderDetails(String orderId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderDetails.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Необходима авторизация');
      }
      throw Exception('Ошибка при загрузке деталей заказа');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<OrderItem>> getOrderItems(String orderId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId/items'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => OrderItem.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Необходима авторизация');
      }
      throw Exception('Ошибка при загрузке товаров заказа');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
