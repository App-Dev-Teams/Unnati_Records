import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';

// date-wise attendance provider
final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, Map<DateTime, AttendanceDay>>(
  (ref) => AttendanceNotifier(),
);

class AttendanceNotifier
    extends StateNotifier<Map<DateTime, AttendanceDay>> {
  AttendanceNotifier() : super({});

  // normalize date (remove time)
  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // mark attendance for a volunteer
  void markAttendance(
    DateTime date,
    Volunteer volunteer,
    AttendanceStatus status,
  ) {
    final d = _normalize(date);

    final day = state[d] ?? AttendanceDay();

    // remove volunteer from all lists first
    final present =
        day.present.where((v) => v.name != volunteer.name).toList();
    final absent =
        day.absent.where((v) => v.name != volunteer.name).toList();
    final deferred =
        day.deferred.where((v) => v.name != volunteer.name).toList();

    // add to selected status list
    if (status == AttendanceStatus.present) {
      present.add(volunteer);
    } else if (status == AttendanceStatus.absent) {
      absent.add(volunteer);
    } else {
      deferred.add(volunteer);
    }

    state = {
      ...state,
      d: AttendanceDay(
        present: present,
        absent: absent,
        deferred: deferred,
      ),
    };
  }

  // remove volunteer completely from a date
  void removeVolunteer(DateTime date, Volunteer volunteer) {
    final d = _normalize(date);
    final day = state[d];

    if (day == null) return;

    state = {
      ...state,
      d: AttendanceDay(
        present:
            day.present.where((v) => v.name != volunteer.name).toList(),
        absent:
            day.absent.where((v) => v.name != volunteer.name).toList(),
        deferred:
            day.deferred.where((v) => v.name != volunteer.name).toList(),
      ),
    };
  }
}
