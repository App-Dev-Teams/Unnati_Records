import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';
import 'package:unnati_app/services/api_service.dart';

class AttendanceService {
  static const String baseUrl =
      'https://unnati-records.onrender.com/api';

    Future<Map<String, String>> _headers() async {
      final token = await ApiService.getToken();

      return {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
    }

  // ---------------------------
  // Fetch volunteers
  // ---------------------------
  Future<List<Volunteer>> fetchVolunteers(
    String? program,
  ) async {
    final uri = Uri.parse(
      "$baseUrl/volunteers/program/get-volunteers",
    ).replace(
      queryParameters:
          program == null || program == "All"
              ? {}
              : {
                  "program": program,
                },
    );
    print(uri);


    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data["users"] as List)
          .map(
            (e) => Volunteer.fromJson(e),
          )
          .toList();
    }

    throw Exception(
      "Failed to fetch volunteers",
    );
  }

  // ---------------------------
  // Mark attendance
  // ---------------------------
  Future<void> markAttendance({
    required DateTime date,
    List<String> present = const [],
    List<String> absent = const [],
    List<String> cancelled = const [],
  }) async {
    final response = await http.patch(
      Uri.parse(
        "$baseUrl/attendance/mark",
      ),
      headers: await _headers(),
      body: jsonEncode(
        {
          "date": date.toIso8601String().split("T")[0],
          "presentUserId": present,
          "absentUserId": absent,
          "cancelledUserId": cancelled,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to mark attendance",
      );
    }
  }

  // ---------------------------
  // Get attendance by date
  // ---------------------------
  Future<Map<String, dynamic>> getAttendanceByDate(DateTime date) async {
    try {
      final uri = Uri.parse(
        "$baseUrl/attendance/date",
      ).replace(
        queryParameters: {
          "date": date.toIso8601String().split("T")[0],
        },
      );

      final response = await http.get(uri,headers: await _headers());
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Server error: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("Error in getAttendanceByDate: $e");
      throw Exception("Failed to fetch attendance: $e");
    }
  }

//----------------------------------
// Get User yearly Attendance Stats
//----------------------------------
  Future<List<dynamic>> getUserYearlyAttendance({
    required String userId,
    required int year,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/attendance/user/$userId/yearly",
    ).replace(
      queryParameters: {
        "year": year.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["data"];
    }

    throw Exception(
      "Failed to fetch yearly attendance",
    );
  }

// ---------------------------
// Get User Attendance Stats
// ---------------------------
Future<Map<String, dynamic>> getUserAttendance({
  required String userId,
  int? month,
  int? year,
}) async {
  try {
    final uri = Uri.parse(
      "$baseUrl/attendance/user/$userId",
    ).replace(
      queryParameters: {
        if (month != null) "month": month.toString(),
        if (year != null) "year": year.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: await _headers(),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to fetch attendance stats",
    );
  } catch (e) {
    throw Exception(
      "Error fetching attendance stats: $e",
    );
  }
}
}