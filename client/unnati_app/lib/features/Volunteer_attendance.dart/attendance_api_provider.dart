import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/services/attendance_service.dart';


final attendanceServiceProvider=
Provider(
  (ref){
    return AttendanceService();
  }
);