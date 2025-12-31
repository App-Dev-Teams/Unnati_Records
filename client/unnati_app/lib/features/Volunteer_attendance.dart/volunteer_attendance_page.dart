import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/attendance_provider.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/search_volunteer.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';

class VolunteerAttendancePage extends ConsumerStatefulWidget {
  const VolunteerAttendancePage({super.key});

  @override
  ConsumerState<VolunteerAttendancePage> createState() =>
      _VolunteerAttendancePageState();
}

class _VolunteerAttendancePageState
    extends ConsumerState<VolunteerAttendancePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  TextEditingController namecontroller = TextEditingController();

  // normalize date (must match provider)
  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // show dialog for marked attendance
  void _showAttendanceDialog(DateTime date, AttendanceDay day) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Attendance Summary',style: TextStyle(fontWeight: FontWeight.bold),),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRESENT LIST
              const Text(
                'Present',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              ...day.present.map(
                (v) => ListTile(title: Text(v.name), subtitle: Text(v.program)),
              ),

              const SizedBox(height: 10),

              // ABSENT LIST
              const Text(
                'Absent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              ...day.absent.map(
                (v) => ListTile(title: Text(v.name), subtitle: Text(v.program)),
              ),

              const SizedBox(height: 10),

              // DEFERRED LIST
              const Text(
                'Deferred',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              ...day.deferred.map(
                (v) => ListTile(title: Text(v.name), subtitle: Text(v.program)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceData = ref.watch(attendanceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        foregroundColor: Colors.white,
        title: Text(
          'Attendance',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: true,
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2025),
                      lastDay: DateTime(2030),

                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },

                      onDaySelected: (selectedDay, focusedDay) {
                        final normalized = _normalize(selectedDay);

                        setState(() {
                          _selectedDay = normalized;
                          _focusedDay = focusedDay;
                        });

                        final dayData = attendanceData[normalized];
                        if (dayData != null) {
                          _showAttendanceDialog(normalized, dayData);
                        }
                      },

                      //calender styling
                      calendarStyle: CalendarStyle(
                        todayDecoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle: const TextStyle(color: Colors.yellow),
                        outsideTextStyle: const TextStyle(
                          color: Color.fromARGB(255, 160, 160, 160),
                        ),
                      ),

                      headerStyle: const HeaderStyle(
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        formatButtonVisible: false,
                      ),

                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.white),
                        weekendStyle: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchVolunteer(selectedDate: _selectedDay),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
