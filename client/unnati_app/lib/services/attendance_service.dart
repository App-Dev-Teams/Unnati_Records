import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';

class AttendanceService {
  static const String baseUrl =
      'http://unnati.onrender.com/api';

  // ---------------------------
  // Fetch volunteers
  // GET /volunteers/program/get-volunteers
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
  // PATCH /attendance/mark
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
      headers: {
        "Content-Type": "application/json",
      },
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
  // GET /attendance/date
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

      final response = await http.get(uri);
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
}