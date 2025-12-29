import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';

// ===== ADDED =====
// Provider for attendance data (date-wise)
final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, Map<DateTime, List<Volunteer>>>(
  (ref) => AttendanceNotifier(),
);

// ===== ADDED =====
class AttendanceNotifier
    extends StateNotifier<Map<DateTime, List<Volunteer>>> {
  AttendanceNotifier() : super({});

  // normalizing date (removing time)
  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // mark attendance
  void markPresent(DateTime date, Volunteer volunteer) {
    final d = _normalize(date);

    final updated = {...state};
    updated.putIfAbsent(d, () => []);

    if (!updated[d]!.any((v) => v.name == volunteer.name)) {
      updated[d]!.add(volunteer);
    }

    state = updated;
  }

  // remove attendance
  void removePresent(DateTime date, Volunteer volunteer) {
    final d = _normalize(date);

    final updated = {...state};
    updated[d]?.removeWhere((v) => v.name == volunteer.name);

    // clean empty dates
    if (updated[d]?.isEmpty ?? false) {
      updated.remove(d);
    }

    state = updated;
  }
}
