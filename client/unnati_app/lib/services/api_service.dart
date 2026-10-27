import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const String baseUrl =
  //     'https://unnati-records-qhgb.onrender.com/api/auth';
  // static const String coreBaseUrl =
  //     'https://unnati-records-qhgb.onrender.com/api';
  // For physical phone with 'adb reverse tcp:3000 tcp:3000':
  static const String baseUrl = 'http://192.168.1.24:3000/api/auth';
static const String coreBaseUrl = 'http://192.168.1.24:3000/api';


  static const Duration _timeout = Duration(seconds: 30);
  static const String liveDoubtBaseUrl =
      'https://unnati-records-qhgb.onrender.com/api/live-doubts';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static SharedPreferences? _prefs;
  static final StreamController<Map<String, dynamic>?> _userDataController =
      StreamController<Map<String, dynamic>?>.broadcast();

  static Stream<Map<String, dynamic>?> get userDataStream =>
      _userDataController.stream;

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
    if (!_userDataController.isClosed) {
      _userDataController.add(null);
    }
  }

  //all about permissions-----------
  static Future<void> savePermissions(List permissions) async {
    final prefs = await _preferences;
    await prefs.setStringList(
      'user_permissions',
      permissions.map((e) => e.toString()).toList(),
    );
  }

  static Future<List<String>> getPermissions() async {
    final prefs = await _preferences;
    return prefs.getStringList('user_permissions') ?? [];
  }

  static Future<bool> hasPermission(String permission) async {
    final permissions = await getPermissions();
    print("Stored Permissions: $permissions");
    print("Checking Permission: $permission");

    return permissions.contains(permission);
  }

  static List<String> permissionsFromUserData(Map<String, dynamic>? user) {
    final permissions = user?['permissions'];
    if (permissions is List) {
      return permissions.map((e) => e.toString()).toList();
    }
    return [];
  }

  static bool isStudentUserData(Map<String, dynamic>? user) {
    if (user == null) return false;
    return user['studentClass'] != null || user['school'] != null;
  }
  //-----------------------------

  static Future<void> saveUserData(
    Map<String, dynamic> user, {
    bool preserveExistingFields = true,
  }) async {
    final prefs = await _preferences;
    try {
      print("saveuserdata $user");
      Map<String, dynamic> payload = Map<String, dynamic>.from(user);

      if (preserveExistingFields) {
        final current = await getUserData();
        if (current != null) {
          final merged = Map<String, dynamic>.from(current)..addAll(payload);
          if (!payload.containsKey('role') && current.containsKey('role')) {
            merged['role'] = current['role'];
          }
          if (!payload.containsKey('permissions') &&
              current.containsKey('permissions')) {
            merged['permissions'] = current['permissions'];
          }
          payload = merged;
        }
      }

      await prefs.setString('user_data', json.encode(payload));
      if (!_userDataController.isClosed) {
        _userDataController.add(payload);
      }
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
      print("getuserdata $data");
      return data;
    } catch (e) {
      print('❌ getUserData parse error: ${e.toString()}');
      return null;
    }
  }

  static Future<void> clearRoleAndNotify() async {
    try {
      final prefs = await _preferences;
      await prefs.remove('user_role');
      await prefs.remove('user_permissions');

      final current = await getUserData();
      if (current != null) {
        final updated = Map<String, dynamic>.from(current);
        updated.remove('role');
        updated.remove('permissions');
        await saveUserData(updated, preserveExistingFields: false);
        if (!_userDataController.isClosed) _userDataController.add(updated);
      } else {
        if (!_userDataController.isClosed) _userDataController.add(null);
      }
      print('✅ ROLE CLEARED AND NOTIFIED');
    } catch (e) {
      print('❌ clearRoleAndNotify error: ${e.toString()}');
    }
  }

  static Future<void> _handleAuthError(http.Response response) async {
    try {
      print('⚠️ AUTH ERROR (${response.statusCode}). Clearing auth state.');
      await removeToken();
      await clearRoleAndNotify();
    } catch (e) {
      print('❌ _handleAuthError failed: ${e.toString()}');
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
        return {
          'success': false,
          'message': 'Empty response from server',
          'statusCode': response.statusCode,
        };
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      // Handle only real auth failures centrally.
      if (response.statusCode == 401) {
        await _handleAuthError(response);
        final errorMessage =
            data['error'] as String? ??
            data['message'] as String? ??
            'Unauthorized';
        print('❌ $operation AUTH ERROR: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
          'errors': data['errors'],
          'statusCode': response.statusCode,
        };
      }

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
        print("responseData = $responseData");

        //permission save
        final permissions = responseData?['permissions'];
        print("permissions✅ = $permissions");
        if (permissions != null && permissions is List) {
          await savePermissions(permissions);
          print("✅ PERMISSIONS SAVED: $permissions");
        }

        if (responseData != null) {
          final role = responseData['role'] as String?;
          if (role != null && role.isNotEmpty) {
            await saveRole(role);
            print('✅ ROLE SAVED: $role');
          }
          await saveUserData(responseData);
          print('✅ USER DATA SAVED: ${await getUserData()}');
        }

        print('✅ $operation SUCCESS');
        return {
          'success': true,
          'message': data['message'] as String? ?? '$operation successful',
          'statusCode': response.statusCode,
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
          'statusCode': response.statusCode,
        };
      }
    } on FormatException catch (e) {
      print('❌ $operation JSON PARSE ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Invalid response format from server',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      print('❌ $operation RESPONSE HANDLING ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Error processing server response',
        'statusCode': 0,
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
      print('📥 $operation Raw Response Status: ${response.body}');

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
        'message': 'Unable to send OTP. Please try again $e',
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
        'message': 'Unable to verify OTP. Please try again $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updatePassword({
    required String email,
    required String newPassword,
    String accountType = 'volunteer',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/update-password'),
            headers: _headers,
            body: json.encode({
              'email': email.trim().toLowerCase(),
              'newPassword': newPassword,
              'accountType': accountType,
            }),
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
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          final errorText = errors
              .map((error) {
                if (error is Map<String, dynamic>) {
                  return error['msg']?.toString() ?? error.toString();
                }
                return error.toString();
              })
              .where((message) => message.trim().isNotEmpty)
              .join(', ');

          if (errorText.isNotEmpty) {
            return {'success': false, 'message': errorText, 'errors': errors};
          }
        }

        return {'success': false, 'message': errorMessage};
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final errorMessage =
          data['error'] as String? ??
          data['message'] as String? ??
          'Failed to update profile';
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final errorText = errors
            .map((error) {
              if (error is Map<String, dynamic>) {
                return error['msg']?.toString() ?? error.toString();
              }
              return error.toString();
            })
            .where((message) => message.trim().isNotEmpty)
            .join(', ');

        if (errorText.isNotEmpty) {
          return {'success': false, 'message': errorText, 'errors': errors};
        }
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      print('❌ UPDATE PROFILE ERROR: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unable to update profile. Please try again.',
      };
    }
  }

  static Future<Map<String, String>> _authHeaders() async {
    final headers = Map<String, String>.from(_headers);
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> createDoubt({
    required String title,
    required String description,
    required String subject,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/doubts/createdoubt'),
            headers: headers,
            body: json.encode({
              'title': title,
              'description': description,
              'subject': subject,
            }),
          )
          .timeout(_timeout);

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        await _handleAuthError(response);
        final errorMessage =
            data['error'] as String? ??
            data['message'] as String? ??
            'Unauthorized';
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        return {
          'success': true,
          'message': 'Doubt created successfully',
          'statusCode': response.statusCode,
          'doubt': data['doubt'],
        };
      }

      return {
        'success': false,
        'message':
            data['error'] as String? ??
            data['message'] as String? ??
            'Failed to create doubt',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to create doubt. Please try again.',
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getMyDoubts() async {
    final headers = await _authHeaders();
    final response = await http
        .get(Uri.parse('$coreBaseUrl/doubts/mydoubts'), headers: headers)
        .timeout(_timeout);

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 401) {
      await _handleAuthError(response);
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      final doubts = (data['data'] as List? ?? []);
      return doubts.cast<Map<String, dynamic>>();
    }

    throw Exception(
      data['error'] as String? ??
          data['message'] as String? ??
          'Failed to fetch doubts',
    );
  }

  static Future<List<Map<String, dynamic>>> getOpenDoubts() async {
    final headers = await _authHeaders();
    final response = await http
        .get(Uri.parse('$coreBaseUrl/doubts/open'), headers: headers)
        .timeout(_timeout);
    print(" OPEN DOUBTS: ${response.body}");

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 401) {
      await _handleAuthError(response);
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      final doubts = (data['data'] as List? ?? []);
      return doubts.cast<Map<String, dynamic>>();
    }

    throw Exception(
      data['error'] as String? ??
          data['message'] as String? ??
          'Failed to fetch open doubts',
    );
  }

  static Future<List<Map<String, dynamic>>> getClosedDoubts() async {
    final headers = await _authHeaders();
    final response = await http
        .get(Uri.parse('$coreBaseUrl/doubts/closed'), headers: headers)
        .timeout(_timeout);
    print(" CLOSED DOUBTS: ${response.body}");

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 401) {
      await _handleAuthError(response);
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      final doubts = (data['data'] as List? ?? []);
      return doubts.cast<Map<String, dynamic>>();
    }

    throw Exception(
      data['error'] as String? ??
          data['message'] as String? ??
          'Failed to fetch closed doubts',
    );
  }

  static Future<Map<String, dynamic>> getDoubtDetails(String doubtId) async {
    final headers = await _authHeaders();
    final response = await http
        .get(Uri.parse('$coreBaseUrl/doubts/$doubtId'), headers: headers)
        .timeout(_timeout);
    print(" DOUBT DETAILS: ${response.body}");

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 401) {
      await _handleAuthError(response);
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      return (data['data'] as Map<String, dynamic>? ?? {});
    }

    throw Exception(
      data['error'] as String? ??
          data['message'] as String? ??
          'Failed to fetch doubt details',
    );
  }

  static Future<List<Map<String, dynamic>>> getDoubtMessages(
    String doubtId,
  ) async {
    final headers = await _authHeaders();
    final response = await http
        .get(
          Uri.parse('$coreBaseUrl/doubts/$doubtId/messages'),
          headers: headers,
        )
        .timeout(_timeout);
    print(" DOUBT MESSAGES: ${response.body}");

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 401) {
      await _handleAuthError(response);
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      final messages = (data['data'] as List? ?? []);
      return messages.cast<Map<String, dynamic>>();
    }

    throw Exception(
      data['error'] as String? ??
          data['message'] as String? ??
          'Failed to fetch messages',
    );
  }

  static Future<Map<String, dynamic>> addDoubtMessage({
    required String doubtId,
    required String message,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/doubts/$doubtId/messages'),
            headers: headers,
            body: json.encode({'message': message}),
          )
          .timeout(_timeout);

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        await _handleAuthError(response);
        final errorMessage =
            data['error'] as String? ??
            data['message'] as String? ??
            'Unauthorized';
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        return {
          'success': true,
          'message': 'Message sent successfully',
          'statusCode': response.statusCode,
          'data': data['message'],
        };
      }

      return {
        'success': false,
        'message':
            data['error'] as String? ??
            data['message'] as String? ??
            'Failed to send message',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to send message. Please try again.',
      };
    }
  }

  static Future<Map<String, dynamic>> addDoubtReply({
    required String doubtId,
    required String message,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/doubts/$doubtId/reply'),
            headers: headers,
            body: json.encode({'message': message}),
          )
          .timeout(_timeout);

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        await _handleAuthError(response);
        final errorMessage =
            data['error'] as String? ??
            data['message'] as String? ??
            'Unauthorized';
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        return {
          'success': true,
          'message': 'Reply sent successfully',
          'statusCode': response.statusCode,
          'data': data['message'],
        };
      }

      return {
        'success': false,
        'message':
            data['error'] as String? ??
            data['message'] as String? ??
            'Failed to send reply',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to send reply. Please try again.',
      };
    }
  }

  static Future<Map<String, dynamic>> resolveDoubt(String doubtId) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .put(
            Uri.parse('$coreBaseUrl/doubts/$doubtId/resolve'),
            headers: headers,
          )
          .timeout(_timeout);

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        await _handleAuthError(response);
        final errorMessage =
            data['error'] as String? ??
            data['message'] as String? ??
            'Unauthorized';
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Doubt resolved successfully',
          'statusCode': response.statusCode,
          'data': data['data'],
        };
      }

      return {
        'success': false,
        'message':
            data['error'] as String? ??
            data['message'] as String? ??
            'Failed to resolve doubt',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to resolve doubt. Please try again.',
      };
    }
  }

  // ================== FOLDER / FILE APIs (Volunteer resources) ==================

  /// Fetch all folders (courses/subjects)
  static Future<List<Map<String, dynamic>>> fetchFolders() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$coreBaseUrl/folders'),
      headers: headers,
    );
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
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$coreBaseUrl/folders'),
      headers: headers,
      body: json.encode({'name': name, 'className': className}),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create folder: ${res.body}');
  }

  /// Delete folder (subject)
  static Future<void> deleteFolder(String folderId) async {
    final headers = await _authHeaders();
    final res = await http.delete(
      Uri.parse('$coreBaseUrl/folders/$folderId'),
      headers: headers,
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
    final headers = await _authHeaders();
    final body = {};
    if (name != null) {
      body['name'] = name;
    }
    if (className != null) {
      body['className'] = className;
    }
    final res = await http.patch(
      Uri.parse('$coreBaseUrl/folders/$id'),
      headers: headers,
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
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$coreBaseUrl/imagekit/auth'),
      headers: headers,
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to get profile ImageKit auth: ${res.body}');
  }

  static Future<Map<String, dynamic>> getProfileImageKitAuth() async {
    final response = await http.get(
      Uri.parse('$coreBaseUrl/imagekit/profile-auth'),
      headers: await _authHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Profile ImageKit authentication failed '
      '(${response.statusCode}): ${response.body}',
    );
  }

  /// Upload a profile picture to ImageKit using http.
  static Future<String> uploadProfilePicture(File imageFile) async {
    final auth = await getProfileImageKitAuth();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
    );

    request.fields['fileName'] =
        'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    request.fields['publicKey'] = auth['publicKey'].toString();
    request.fields['token'] = auth['token'].toString();
    request.fields['signature'] = auth['signature'].toString();
    request.fields['expire'] = auth['expire'].toString();

    if (auth['folder'] != null) {
      request.fields['folder'] = auth['folder'].toString();
    }

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('ImageKit upload failed: ${response.body}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final imageUrl = data['url'] as String?;

    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('ImageKit did not return an image URL');
    }

    return imageUrl;
  }

  /// Save the uploaded profile picture URL in our backend.
  static Future<Map<String, dynamic>> updateProfilePicture(
    String imageUrl,
  ) async {
    final headers = await _authHeaders();

    final res = await http
        .put(
          Uri.parse('$coreBaseUrl/profile-picture'),
          headers: headers,
          body: json.encode({'profilePic': imageUrl}),
        )
        .timeout(_timeout);

    final data = json.decode(res.body) as Map<String, dynamic>;

    if (res.statusCode >= 200 &&
        res.statusCode < 300 &&
        data['success'] == true) {
      final updated = data['data'];

      if (updated is Map<String, dynamic>) {
        await saveUserData(updated);
      } else {
        final current = await getUserData();
        if (current != null) {
          await saveUserData({...current, 'profilePic': imageUrl});
        }
      }

      return {
        'success': true,
        'message': data['message'] ?? 'Profile picture updated',
        'data': data['data'],
      };
    }

    return {
      'success': false,
      'message':
          data['message'] ??
          data['error'] ??
          'Failed to update profile picture',
    };
  }

  /// Fetch all files for a folder
  static Future<List<Map<String, dynamic>>> fetchFilesByFolder(
    String folderId,
  ) async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$coreBaseUrl/files/folder/$folderId'),
      headers: headers,
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
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$coreBaseUrl/files'),
      headers: headers,
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
    final headers = await _authHeaders();
    final res = await http.patch(
      Uri.parse('$coreBaseUrl/files/$id'),
      headers: headers,
      body: json.encode({'displayName': displayName}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body);
    }
    throw Exception('Failed updating file');
  }

  /// DELETE FILE
  static Future<void> deleteFile(String id) async {
    final headers = await _authHeaders();
    final res = await http.delete(
      Uri.parse('$coreBaseUrl/files/$id'),
      headers: headers,
    );
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

  // ================= QUIZ SERVICES =================
  static Future<List<Map<String, dynamic>>> getQuizzes() async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$coreBaseUrl/quizzes/get_quizzes'), headers: headers)
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception(data['message'] ?? 'Failed to load quizzes');
      }
    } catch (e) {
      print('getQuizzes error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getQuizById(String id) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$coreBaseUrl/quizzes/get_quiz/$id'), headers: headers)
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return Map<String, dynamic>.from(data['data'] ?? {});
      } else {
        throw Exception(data['message'] ?? 'Failed to load quiz');
      }
    } catch (e) {
      print('getQuizById error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> submitQuiz({
    required String quizId,
    required List<Map<String, String>> answers,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/quizzes/take_quiz/$quizId/submit'),
            headers: headers,
            body: jsonEncode({'answers': answers}),
          )
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Quiz submitted successfully',
          'data': data['data'],
        };
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'alreadySubmitted': true,
          'message': data['message'] ?? 'You have already submitted this quiz',
        };
      } else {
        return {
          'success': false,
          'alreadySubmitted': false,
          'message': data['message'] ?? 'Failed to submit quiz',
        };
      }
    } catch (e) {
      print('submitQuiz error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> uploadQuiz({
    required String title,
    required String targetClass,
    required List<Map<String, dynamic>> questions,
    String status = 'published',
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$coreBaseUrl/quizzes/upload_quiz'),
            headers: headers,
            body: jsonEncode({
              'title': title,
              'targetClass': targetClass,
              'questions': questions,
              'status': status,
            }),
          )
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Quiz uploaded successfully',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to upload quiz',
        };
      }
    } catch (e) {
      print('uploadQuiz error: $e');
      rethrow;
    }
  }

  static Future<void> saveLocalQuizAttempt(
    String quizId,
    int score,
    int total,
  ) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(
        'quiz_attempt_$quizId',
        jsonEncode({
          'score': score,
          'total': total,
          'submittedAt': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      print('saveLocalQuizAttempt error: $e');
    }
  }

  static Future<Map<String, dynamic>?> getLocalQuizAttempt(
    String quizId,
  ) async {
    try {
      final prefs = await _preferences;
      final raw = prefs.getString('quiz_attempt_$quizId');
      if (raw != null) {
        return jsonDecode(raw) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('getLocalQuizAttempt error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getMyQuizAttempts() async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$coreBaseUrl/quizzes/my_attempts'), headers: headers)
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return Map<String, dynamic>.from(data['data'] ?? {});
      } else {
        throw Exception(data['message'] ?? 'Failed to load quiz attempts');
      }
    } catch (e) {
      print('getMyQuizAttempts error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getQuizSubmissions(String quizId) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(
            Uri.parse('$coreBaseUrl/quizzes/quiz_attempts/$quizId'),
            headers: headers,
          )
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'quiz': data['quiz'] ?? {},
          'count': data['count'] ?? 0,
          'submissions': List<Map<String, dynamic>>.from(data['data'] ?? []),
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to load quiz submissions');
      }
    } catch (e) {
      print('getQuizSubmissions error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getStudentQuizStats(
    String studentId,
  ) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(
            Uri.parse('$coreBaseUrl/quizzes/student_stats/$studentId'),
            headers: headers,
          )
          .timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return Map<String, dynamic>.from(data['data'] ?? {});
      } else {
        throw Exception(data['message'] ?? 'Failed to load student quiz stats');
      }
    } catch (e) {
      print('getStudentQuizStats error: $e');
      rethrow;
    }
  }

  // ================== LIVE VIDEO DOUBTS & CONFERENCES ==================

  static Map<String, dynamic> _safeDecode(http.Response response) {
    try {
      final body = response.body.trim();
      if (body.isEmpty)
        return {'success': false, 'error': 'Empty response from server'};
      if (body.startsWith('{') || body.startsWith('[')) {
        return json.decode(body) as Map<String, dynamic>;
      }
      return {'success': false, 'error': body};
    } catch (e) {
      return {'success': false, 'error': 'Invalid JSON: $e'};
    }
  }

  static Future<Map<String, dynamic>> requestLiveCall({
    required String subject,
    required String topic,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$liveDoubtBaseUrl/request'),
            headers: headers,
            body: json.encode({'subject': subject, 'topic': topic}),
          )
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'success': false, 'error': 'Failed to request live call: $e'};
    }
  }

  static Future<Map<String, dynamic>> getLiveQueue() async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$liveDoubtBaseUrl/queue'), headers: headers)
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'success': false, 'error': 'Failed to fetch queue: $e'};
    }
  }

  static Future<Map<String, dynamic>> acceptLiveCall(String sessionId) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$liveDoubtBaseUrl/$sessionId/accept'),
            headers: headers,
          )
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'success': false, 'error': 'Failed to accept call: $e'};
    }
  }

  static Future<Map<String, dynamic>> checkMyLiveStatus() async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$liveDoubtBaseUrl/my-status'), headers: headers)
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'active': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> cancelLiveRequest() async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(Uri.parse('$liveDoubtBaseUrl/cancel'), headers: headers)
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<void> endLiveCall(String sessionId) async {
    try {
      final headers = await _authHeaders();
      await http
          .post(Uri.parse('$liveDoubtBaseUrl/$sessionId/end'), headers: headers)
          .timeout(_timeout);
    } catch (_) {}
  }

  static Future<Map<String, dynamic>> scheduleLiveCall(
    String sessionId,
    DateTime startTime, {
    int durationMinutes = 30,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .put(
            Uri.parse('$liveDoubtBaseUrl/$sessionId/schedule'),
            headers: headers,
            body: json.encode({
              'scheduledStartTime': startTime.toIso8601String(),
              'durationMinutes': durationMinutes,
            }),
          )
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'success': false, 'error': 'Failed to schedule call: $e'};
    }
  }

  static Future<Map<String, dynamic>> startLiveCall(String sessionId) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$liveDoubtBaseUrl/$sessionId/start'),
            headers: headers,
          )
          .timeout(_timeout);

      return _safeDecode(response);
    } catch (e) {
      return {'success': false, 'error': 'Failed to join/start call: $e'};
    }
  }
}
