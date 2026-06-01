import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/services/attendance_service.dart';


final attendanceServiceProvider=
Provider(
  (ref){
    return AttendanceService();
  }
);

final userAttendanceProvider =
FutureProvider.autoDispose.family<Map<String, dynamic>, ({
  String userId,
  int? month,
  int? year,
})>((ref, params) async {
  final service = ref.read(attendanceServiceProvider);

  return service.getUserAttendance(
    userId: params.userId,
    month: params.month,
    year: params.year,
  );
});

final selectedYearProvider =
    StateProvider<int>((ref) {
  return DateTime.now().year;
});

final yearlyAttendanceProvider =
  FutureProvider.autoDispose.family<List<dynamic>, ({
  String userId,
  int year,
})>((ref, params) async {
  final service = ref.read(attendanceServiceProvider);

  return service.getUserYearlyAttendance(
    userId: params.userId,
    year: params.year,
  );
});