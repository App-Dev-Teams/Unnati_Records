import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://unnati-records.onrender.com/api/auth';
  static const Duration _timeout = Duration(seconds: 30);
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static SharedPreferences? _prefs;
  static Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await _preferences;
    return prefs.getString('auth_token');
  }

  static Future<void> removeToken() async {
    final prefs = await _preferences;
    await prefs.remove('auth_token');
  }

  static Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
    String operation,
  ) async {
    try {
      print('📥 $operation Response Status: ${response.statusCode}');
      print('📥 $operation Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Empty response from server',
        };
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      // Check if request was successful
      if (response.statusCode == 200 && data['success'] == true) {
        // Save token if present
        final token = data['token'] as String?;
        if (token != null && token.isNotEmpty) {
          await saveToken(token);
          final tokenPreview = token.length > 20 
              ? '${token.substring(0, 20)}...' 
              : token;
          print('✅ TOKEN SAVED: $tokenPreview');
        }

        print('✅ $operation SUCCESS');
        return {
          'success': true,
          'message': data['message'] as String? ?? '$operation successful',
          'token': token,
          'data': data['data'],
        };
      } else {
        final errorMessage = data['error'] as String? ?? 
                           data['message'] as String? ?? 
                           '$operation failed';
        print('❌ $operation FAILED: $errorMessage');
        
        return {
          'success': false,
          'message': errorMessage,
          'errors': data['errors'],
        };
      }
    } on FormatException catch (e) {
      print('❌ $operation JSON PARSE ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Invalid response format from server',
      };
    } catch (e) {
      print('❌ $operation RESPONSE HANDLING ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Error processing server response',
      };
    }
  }

  static Future<Map<String, dynamic>> _makeRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    required String operation,
  }) async {
    try {
      print('🔵 $operation REQUEST: $baseUrl/$endpoint');
      print('📤 $operation Data: ${body.keys.join(", ")}');
      
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: _headers,
            body: json.encode(body),
          )
          .timeout(_timeout);

      return await _handleResponse(response, operation);
    } on http.ClientException catch (e) {
      print('❌ $operation NETWORK ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Network error: Please check your internet connection',
      };
    } on FormatException catch (e) {
      print('❌ $operation FORMAT ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Invalid data format',
      };
    } catch (e) {
      print('❌ $operation ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    String role = 'volunteer',
  }) async {
    return await _makeRequest(
      endpoint: 'signup',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
      operation: 'SIGNUP',
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _makeRequest(
      endpoint: 'login',
      body: {
        'email': email,
        'password': password,
      },
      operation: 'LOGIN',
    );
  }
}