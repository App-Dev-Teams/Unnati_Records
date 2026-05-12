import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminApiService {
  static const String baseUrl = 'https://unnati-records.onrender.com/api/auth';
  static const String coreBaseUrl = 'https://unnati-records.onrender.com/api';
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
    await prefs.setString('admin_auth_token', token);
  }

  static Future<void> saveAdminName(String name) async {
    final prefs = await _preferences;
    await prefs.setString('admin_name', name);
  }

  static Future<String?> getToken() async {
    final prefs = await _preferences;
    return prefs.getString('admin_auth_token');
  }

  static Future<String?> getAdminName() async {
    final prefs = await _preferences;
    return prefs.getString('admin_name');
  }

  static Future<void> logout() async {
    final prefs = await _preferences;
    await prefs.remove('admin_auth_token');
    await prefs.remove('admin_name');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: _headers,
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        final token = data['token'] as String?;
        final userData = data['data'] as Map<String, dynamic>?;
        final name = userData?['name'] as String?;
        if (token != null && token.isNotEmpty) {
          await saveToken(token);
        }
        if (name != null && name.isNotEmpty) {
          await saveAdminName(name);
        }
        return {'success': true, 'message': data['message'], 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    int startYear,
    int endYear,
    int? rollNo,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/signup'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'batch': {'startYear': startYear, 'endYear': endYear},
              'rollNo': rollNo,
            }),
          )
          .timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        final token = data['token'] as String?;
        final userData = data['data'] as Map<String, dynamic>?;
        final name = userData?['name'] as String?;
        if (token != null && token.isNotEmpty) {
          await saveToken(token);
        }
        if (name != null && name.isNotEmpty) {
          await saveAdminName(name);
        }
        return {'success': true, 'message': data['message'], 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getImageKitAuth() async {
    final res = await http.get(Uri.parse('$coreBaseUrl/imagekit/auth'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to get ImageKit auth: ${res.body}');
  }

  static Future<Map<String, dynamic>> createFile({
    required String originalName,
    required String displayName,
    required String link,
    required String folderId,
    required String type,
    required String imagekitFileId,
  }) async {
    final res = await http.post(
      Uri.parse('$coreBaseUrl/files'),
      headers: _headers,
      body: jsonEncode({
        'originalName': originalName,
        'displayName': displayName,
        'link': link,
        'folder': folderId,
        'type': type,
        'imagekitFileId': imagekitFileId,
      }),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create file: ${res.body}');
  }

  static Future<List<Map<String, dynamic>>> fetchFolders() async {
    final res = await http.get(Uri.parse('$coreBaseUrl/folders'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch folders: ${res.body}');
  }

  static Future<Map<String, dynamic>> createFolder({
    required String name,
    required String className,
  }) async {
    final res = await http.post(
      Uri.parse('$coreBaseUrl/folders'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'className': className,
      }),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create folder: ${res.body}');
  }

  static Future<List<Map<String, dynamic>>> fetchFilesByFolder(
    String folderId,
  ) async {
    final res = await http.get(Uri.parse('$coreBaseUrl/files/folder/$folderId'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch files: ${res.body}');
  }
}
