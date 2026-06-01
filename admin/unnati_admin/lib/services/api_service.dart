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

  static Future<String?> getToken() async {
    final prefs = await _preferences;
    return prefs.getString('admin_auth_token');
  }

  static Future<void> saveAdminName(String name) async {
    final prefs = await _preferences;
    await prefs.setString('admin_name', name);
  }

  static Future<void> saveAdminData(Map<String, dynamic> data) async {
    final prefs = await _preferences;
    await prefs.setString('admin_data', jsonEncode(data));
  }

  static Future<String?> getAdminName() async {
    final prefs = await _preferences;
    return prefs.getString('admin_name');
  }

  static Future<Map<String, dynamic>?> getAdminData() async {
    final prefs = await _preferences;
    final dataString = prefs.getString('admin_data');
    if (dataString != null) {
      return jsonDecode(dataString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await _preferences;
    await prefs.remove('admin_auth_token');
    await prefs.remove('admin_name');
    await prefs.remove('admin_data');
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
        if (userData != null) {
          await saveAdminData(userData);
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

  static Future<List<Map<String, dynamic>>> fetchVolunteers() async {
    try {
      final res = await http.get(Uri.parse('$coreBaseUrl/volunteers/get-volunteers'));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        if (data is Map && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      }
      throw Exception('Failed to fetch volunteers: ${res.body}');
    } catch (e) {
      throw Exception('Failed to fetch volunteers: $e');
    }
  }

  static Future<Map<String, List<Map<String, dynamic>>>> fetchVolunteersByProgram() async {
    try {
      // Group volunteers by program
      Map<String, List<Map<String, dynamic>>> grouped = {
        'DigiXplore': [],
        'Netritva': [],
        'Akshar': [],
      };
      
      // Fetch volunteers for each program separately
      final programs = ['DigiXplore', 'Netritva', 'Akshar'];
      for (var program in programs) {
        final uri = Uri.parse('$coreBaseUrl/volunteers/program/get-volunteers')
            .replace(queryParameters: {'program': program});
        
        final res = await http.get(uri);
        
        if (res.statusCode >= 200 && res.statusCode < 300) {
          final data = jsonDecode(res.body);
          if (data is Map && data['users'] != null && data['users'] is List) {
            grouped[program] = List<Map<String, dynamic>>.from(data['users']);
          }
        }
      }
      
      return grouped;
    } catch (e) {
      throw Exception('Failed to fetch volunteers: $e');
    }
  }

  static Future<Map<String, dynamic>> assignRoleToVolunteer(String userId, String role) async {
    try {
      final response = await http.put(
        Uri.parse('$coreBaseUrl/volunteers/assign-role'),
        headers: _headers,
        body: jsonEncode({
          'userId': userId,
          'role': role,
        }),
      ).timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': data['message'], 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to assign role',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAssignedLeads() async {
    try {
      // Use the same method as fetchVolunteersByProgram to get program info
      final volunteersGrouped = await fetchVolunteersByProgram();
      
      List<Map<String, dynamic>> allLeads = [];
      
      // Go through each program and filter for leads
      for (var program in volunteersGrouped.keys) {
        final volunteers = volunteersGrouped[program] ?? [];
        final leads = volunteers
            .where((v) => (v['role'] ?? '').toString().contains('Lead'))
            .toList();
        
        // Ensure program field is set correctly
        for (var lead in leads) {
          lead['program'] = program;
        }
        
        allLeads.addAll(leads);
      }
      
      return allLeads;
    } catch (e) {
      throw Exception('Failed to fetch assigned leads: $e');
    }
  }

  // Forgot Password - Send OTP
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$coreBaseUrl/otp/send-otp'),
        headers: _headers,
        body: jsonEncode({'email': email}),
      ).timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': data['message'] ?? 'OTP sent successfully'};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$coreBaseUrl/otp/verify-otp'),
        headers: _headers,
        body: jsonEncode({'email': email, 'otp': otp}),
      ).timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': data['message'] ?? 'OTP verified successfully'};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Invalid OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update Password (Reset Password)
  static Future<Map<String, dynamic>> updatePassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update-password'),
        headers: _headers,
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      ).timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': data['message'] ?? 'Password updated successfully'};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Failed to update password',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update Profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.put(
        Uri.parse('$baseUrl/update-profile'),
        headers: headers,
        body: jsonEncode(profileData),
      ).timeout(_timeout);

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300 && data['success'] == true) {
        // Update local storage with new data
        if (data['data'] != null) {
          await saveAdminData(data['data']);
        }
        return {'success': true, 'message': data['message'] ?? 'Profile updated successfully', 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}


