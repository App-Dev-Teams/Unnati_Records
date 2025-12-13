import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://unnati-records.onrender.com/api/auth';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    String role = 'volunteer',
  }) async {
    try {
      print('🔵 SIGNUP REQUEST: $baseUrl/signup');
      print('📤 Data: name=$name, email=$email, role=$role');
      
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ SIGNUP SUCCESS');
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        print('❌ SIGNUP FAILED: ${data['error'] ?? data['message']}');
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Signup failed',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      print('❌ SIGNUP ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔵 LOGIN REQUEST: $baseUrl/login');
      print('📤 Data: email=$email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (data['token'] != null) {
          await saveToken(data['token']);
          print('✅ TOKEN SAVED: ${data['token'].substring(0, 20)}...');
        }
        print('✅ LOGIN SUCCESS');
        return {
          'success': true,
          'message': data['message'],
          'token': data['token'],
          'data': data['data'],
        };
      } else {
        print('❌ LOGIN FAILED: ${data['message']}');
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('❌ LOGIN ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}