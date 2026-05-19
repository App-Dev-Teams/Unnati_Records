import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.101:3000/api/auth';
  static const String coreBaseUrl = 'http://192.168.0.101:3000/api';
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

  static Future<void> saveRole(String role) async {
    final prefs = await _preferences;
    await prefs.setString('user_role', role);
  }

  static Future<String?> getRole() async {
    final prefs = await _preferences;
    return prefs.getString('user_role');
  }

  static Future<void> clearAllData() async {
    final prefs = await _preferences;
    await prefs.clear();
  }

  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await _preferences;
    try {
      print("saveuserdata ${user}");
      await prefs.setString('user_data', json.encode(user));
    } catch (e) {
      print('❌ saveUserData error: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _preferences;
    final str = prefs.getString('user_data');
    if (str == null) return null;
    try {
      final Map<String, dynamic> data = json.decode(str);
      print("getuserdata ${data}");
      return data;
    } catch (e) {
      print('❌ getUserData parse error: ${e.toString()}');
      return null;
    }
  }

  static Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
    String operation,
  ) async {
    try {
      print('📥 $operation Response Status: ${response.statusCode}');
      print('📥 $operation Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      // Treat any 2xx + success:true as successful
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        // Save token if present
        final token = data['token'] as String?;
        if (token != null && token.isNotEmpty) {
          await saveToken(token);
          final tokenPreview = token.length > 20
              ? '${token.substring(0, 20)}...'
              : token;
          print('✅ TOKEN SAVED: $tokenPreview');
        }

        // Save role if present in response data
        final responseData = data['data'] as Map<String, dynamic>?;
        if (responseData != null) {
          final role = responseData['role'] as String?;
          if (role != null && role.isNotEmpty) {
            await saveRole(role);
            print('✅ ROLE SAVED: $role');
          }
        }

        print('✅ $operation SUCCESS');
        return {
          'success': true,
          'message': data['message'] as String? ?? '$operation successful',
          'token': token,
          'data': data['data'],
        };
      } else {
        final errorMessage =
            data['error'] as String? ??
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
      return {'success': false, 'message': 'Error processing server response'};
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
      return {'success': false, 'message': 'Invalid data format'};
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
    required String program,
    String role = 'volunteer',
    String? phoneNo,
  }) async {
    return await _makeRequest(
      endpoint: 'signup',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'program': program,
        'phoneNo': phoneNo,
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
      body: {'email': email, 'password': password},
      operation: 'LOGIN',
    );
  }

  static Future<Map<String, dynamic>> studentSignup({
    required String name,
    required String email,
    required String password,
    required String phoneNo,
    required String studentClass,
    required String school,
  }) async {
    return await _makeRequest(
      endpoint: 'studentSignup',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phoneNo': phoneNo,
        'studentClass': studentClass,
        'school': school,
      },
      operation: 'STUDENT_SIGNUP',
    );
  }

  static Future<Map<String, dynamic>> studentLogin({
    required String email,
    required String password,
  }) async {
    return await _makeRequest(
      endpoint: 'studentLogin',
      body: {'email': email, 'password': password},
      operation: 'STUDENT_LOGIN',
    );
  }

  static Future<Map<String, dynamic>> sendOtp({required String email}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/otp/send-otp'),
            headers: _headers,
            body: json.encode({'email': email}),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': data['message'] as String? ?? 'OTP sent successfully',
        };
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final errorMessage =
          data['error'] as String? ??
          data['message'] as String? ??
          'Failed to send OTP';
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to send OTP. Please try again.',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/otp/verify-otp'),
            headers: _headers,
            body: json.encode({'email': email, 'otp': otp}),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': data['message'] as String? ?? 'OTP verified successfully',
        };
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final errorMessage =
          data['error'] as String? ??
          data['message'] as String? ??
          'Failed to verify OTP';
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to verify OTP. Please try again.',
      };
    }
  }

  static Future<Map<String, dynamic>> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/update-password'),
            headers: _headers,
            body: json.encode({'email': email, 'newPassword': newPassword}),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message':
              data['message'] as String? ?? 'Password updated successfully',
        };
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final errorMessage =
          data['error'] as String? ??
          data['message'] as String? ??
          'Failed to update password';
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to update password. Please try again.',
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phoneNo,
    String? program,
    String? branch,
    int? batchYear,
    String? studentClass,
    String? school,
  }) async {
    try {
      final token = await getToken();
      final headers = Map<String, String>.from(_headers);
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phoneNo != null) body['phoneNo'] = phoneNo;
      if (program != null) body['program'] = program;
      if (branch != null) body['branch'] = branch;
      if (batchYear != null) body['batchYear'] = batchYear;
      if (studentClass != null) body['studentClass'] = studentClass;
      if (school != null) body['school'] = school;

      final response = await http
          .put(
            Uri.parse('$baseUrl/update-profile'),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;

        if (success) {
          final updated = data['data'] as Map<String, dynamic>?;
          if (updated != null) {
            await saveUserData(updated);
          }

          return {
            'success': true,
            'message': data['message'] as String? ?? 'Profile updated',
            'data': updated,
          };
        }

        final errorMessage =
            data['error'] as String? ??
            data['message'] as String? ??
            'Failed to update profile';
        return {'success': false, 'message': errorMessage};
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final errorMessage =
          data['error'] as String? ??
          data['message'] as String? ??
          'Failed to update profile';
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      print('❌ UPDATE PROFILE ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unable to update profile. Please try again.',
      };
    }
  }

  // ================== FOLDER / FILE APIs (Volunteer resources) ==================

  /// Fetch all folders (courses/subjects)
  static Future<List<Map<String, dynamic>>> fetchFolders() async {
    final res = await http.get(Uri.parse('$coreBaseUrl/folders'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = json.decode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch folders: ${res.body}');
  }

  /// Create a new folder (course/subject)
  static Future<Map<String, dynamic>> createFolder({
    required String name,
    required String className,
  }) async {
    final res = await http.post(
      Uri.parse('$coreBaseUrl/folders'),
      headers: _headers,
      body: json.encode({'name': name, 'className': className}),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create folder: ${res.body}');
  }

  /// Delete folder (subject)
  static Future<void> deleteFolder(String folderId) async {
    final res = await http.delete(
      Uri.parse('$coreBaseUrl/folders/$folderId'),
      headers: _headers,
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to delete folder: ${res.body}');
    }
  }

  //Rename folder
  static Future<Map<String, dynamic>> updateFolder({
    required String id,
    String? name,
    String? className,
  }) async {
    final body = {};
    if (name != null) {
      body['name'] = name;
    }
    if (className != null) {
      body['className'] = className;
    }
    final res = await http.patch(
      Uri.parse('$coreBaseUrl/folders/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to update folder');
  }

  //=====================================FILE APIs==========================================
  /// Get ImageKit auth parameters from backend
  static Future<Map<String, dynamic>> getImageKitAuth() async {
    final res = await http.get(Uri.parse('$coreBaseUrl/imagekit/auth'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to get ImageKit auth: ${res.body}');
  }

  /// Fetch all files for a folder
  static Future<List<Map<String, dynamic>>> fetchFilesByFolder(
    String folderId,
  ) async {
    final res = await http.get(
      Uri.parse('$coreBaseUrl/files/folder/$folderId'),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = json.decode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch files: ${res.body}');
  }

  /// Create a file metadata entry in backend after uploading to ImageKit
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
      body: json.encode({
        'originalName': originalName,
        'displayName': displayName,
        'link': link,
        'folder': folderId,
        'type': type,
        'imagekitFileId': imagekitFileId,
      }),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create file: ${res.body}');
  }

  /// UPDATE FILE NAME
  static Future<Map<String, dynamic>> updateFile({
    required String id,
    required String displayName,
  }) async {
    final res = await http.patch(
      Uri.parse('$coreBaseUrl/files/$id'),
      headers: _headers,
      body: json.encode({'displayName': displayName}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body);
    }
    throw Exception('Failed updating file');
  }

  /// DELETE FILE
  static Future<void> deleteFile(String id) async {
    final res = await http.delete(Uri.parse('$coreBaseUrl/files/$id'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed deleting file');
    }
  }

  //get schools
  static Future<List<String>> getSchools() async {
    try {
      final url = Uri.parse('$coreBaseUrl/schools/get-schools');

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final schools = data['data'] as List;

        return schools.map((e) => e['name'].toString()).toList();
      }

      throw Exception('Failed to fetch schools: ${res.body}');
    } catch (e) {
      throw Exception('Error fetching schools: $e');
    }
  }
}
