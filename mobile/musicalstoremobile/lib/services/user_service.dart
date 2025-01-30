import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicalstoremobile/models/user.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<User> getUserProfile() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/user/password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}