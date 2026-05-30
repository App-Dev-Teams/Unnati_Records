import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/attendance_provider.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/attendance_api_provider.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/search_volunteer.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/self_attendance_page.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';
import 'package:unnati_app/services/api_service.dart';

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
  bool hasAttendancePermission = false;
  bool isLoadingPermission = true;

  TextEditingController namecontroller = TextEditingController();

  // normalize date (must match provider)
  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<void> checkPermission() async {
    final allowed = await ApiService.hasPermission(
      "MARK_ATTENDANCE",
    );

    setState(() {
      hasAttendancePermission = allowed;
      isLoadingPermission = false;
    });
  }

  // show dialog for marked attendance
  void _showAttendanceDialog(
    Map<String, dynamic> data,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Attendance Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRESENT
              const Text(
                'Present',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              ...(data["present"] as List).map(
                (v) => ListTile(
                  title: Text(v["name"]),
                  
                ),
              ),

              const SizedBox(height: 12),

              // ABSENT
              const Text(
                'Absent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              ...(data["absent"] as List).map(
                (v) => ListTile(
                  title: Text(v["name"]),
                  
                ),
              ),

              const SizedBox(height: 12),

              // CANCELLED
              const Text(
                'Cancelled',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              ...(data["cancelled"] as List).map(
                (v) => ListTile(
                  title: Text(v["name"]),
                  
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
    //final attendanceData = ref.watch(attendanceProvider);

    if (isLoadingPermission) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

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

      body:!hasAttendancePermission
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 70,
              color: Colors.grey,
            ),

             SizedBox(height: 10.h),

            const Text(
              "You don't have access to mark attendance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

             SizedBox(height: 10.h),

            TextButton(
              onPressed: () async {
                final userData = await ApiService.getUserData();
                print("User Data: $userData");
                final userId = userData?["id"];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    
                    builder: (_) =>
                        SelfAttendancePage(userId: userId??' ',)
                  ),
                );
              },
              child: const Text(
                "View Your Attendance",
              ),
            )
          ],
        ),
      )
      :GestureDetector(
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

                      enabledDayPredicate: (day){
                        final today = DateTime.now();
                        final normalizedToday = DateTime(today.year,today.month,today.day+1);

                        return !day.isAfter(normalizedToday);
                      },

                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },

                      onDaySelected: (selectedDay, focusedDay) async {
                        final normalized = _normalize(selectedDay);
                        setState(() {
                          _selectedDay = normalized;
                          _focusedDay = focusedDay;
                        });
                         try {
                          final service =
                              ref.read(
                            attendanceServiceProvider,
                          );
                          final data =
                              await service
                                  .getAttendanceByDate(
                            normalized,
                          );

                          final notifier = ref.read(attendanceProvider.notifier);

                          notifier.setAttendanceFromBackend(
                            normalized,
                            (data["present"] as List)
                                .map((e) => Volunteer.fromJson(e))
                                .toList(),
                            (data["absent"] as List)
                                .map((e) => Volunteer.fromJson(e))
                                .toList(),
                            (data["cancelled"] as List)
                                .map((e) => Volunteer.fromJson(e))
                                .toList(),
                          );
                          
                          final hasAttendance =
                          (data["present"]as List).isNotEmpty 
                          ||(data["absent"]as List).isNotEmpty 
                          ||(data["cancelled"]as List).isNotEmpty;
                          if (hasAttendance) {
                            _showAttendanceDialog(
                              data,
                            );
                          }
                        }catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(
                                "Failed to load attendance ${e.toString()}",
                              ),
                            ),
                          );
                        }
                        // final dayData = attendanceData[normalized];
                        // if (dayData != null) {
                        //   _showAttendanceDialog(normalized, dayData);
                        // }
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
