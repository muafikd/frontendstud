import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicalstoremobile/models/cart_item.dart';

class CartService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<void> updateQuantity(int cartItemId, bool increase) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.put(
        Uri.parse(
            '$baseUrl/cart/${increase ? "increase" : "decrease"}/$cartItemId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка при изменении количества');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('$baseUrl/cart/add?productId=$productId&quantity=$quantity'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка при добавлении товара в корзину');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      print('Fetching cart items...'); // Для отладки
      final response = await http.get(
        Uri.parse('$baseUrl/cart/view'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Cart response status: ${response.statusCode}'); // Для отладки
      print('Cart response body: ${response.body}'); // Для отладки

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final items = jsonData.map((item) => CartItem.fromJson(item)).toList();
        print('Parsed cart items: $items'); // Для отладки
        return items;
      } else if (response.statusCode == 401) {
        throw Exception('Необходима авторизация');
      }
      throw Exception('Ошибка при загрузке корзины');
    } catch (e) {
      print('Error in getCartItems: $e'); // Для отладки
      throw Exception(e.toString());
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove/$cartItemId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка при удалении товара');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> increaseQuantity(int cartItemId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Необходима авторизация');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/cart/increase/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка при увеличении количества');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> decreaseQuantity(int cartItemId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Необходима авторизация');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/cart/decrease/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка при уменьшении количества');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> checkout() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('$baseUrl/orders/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      print('Checkout response status: ${response.statusCode}'); // Для отладки
      print('Checkout response body: ${response.body}'); // Для отладки

      if (response.statusCode == 200) {
        final orderData = json.decode(response.body);
        print('Parsed order data: $orderData'); // Для отладки

        return {
          'orderId': orderData['orderId']?.toString() ?? '',
          'totalPrice': orderData['totalPrice']?.toString() ?? '0.0'
        };
      }
      throw Exception('Ошибка при оформлении заказа: ${response.statusCode}');
    } catch (e) {
      print('Checkout error: $e'); // Для отладки
      throw Exception(e.toString());
    }
  }
}
