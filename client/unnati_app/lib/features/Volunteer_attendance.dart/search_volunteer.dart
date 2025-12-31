import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/attendance_provider.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';

class SearchVolunteer extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const SearchVolunteer({
    super.key,
    required this.selectedDate,
  });

  @override
  ConsumerState<SearchVolunteer> createState() => _SearchVolunteerState();
}

class _SearchVolunteerState extends ConsumerState<SearchVolunteer> {
  String? selectedProgram;
  String searchText = '';

  // programs list
  final List<String> programs = ['DigiXplore', 'Netritva', 'Akshar', 'All'];

  // static volunteers list
  final List<Volunteer> allVolunteers = [
    Volunteer(name: 'Rahul Sharma', program: 'DigiXplore'),
    Volunteer(name: 'Priyanshu Kumar', program: 'DigiXplore'),
    Volunteer(name: 'Ankit Verma', program: 'Netritva'),
    Volunteer(name: 'Sneha Singh', program: 'Akshar'),
    Volunteer(name: 'Aman Gupta', program: 'Netritva'),
  ];

  // get attendance status of a volunteer for selected date
  AttendanceStatus? _getStatus(
    Volunteer volunteer,
    Map<DateTime, AttendanceDay> attendanceData,
  ) {
    final date = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    final day = attendanceData[date];
    if (day == null) return null;

    if (day.present.any((v) => v.name == volunteer.name)) {
      return AttendanceStatus.present;
    }
    if (day.absent.any((v) => v.name == volunteer.name)) {
      return AttendanceStatus.absent;
    }
    if (day.deferred.any((v) => v.name == volunteer.name)) {
      return AttendanceStatus.deferred;
    }
    return null;
  }

  // bottom sheet to mark attendance
  void _showAttendanceOptions(Volunteer volunteer) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Present'),
            onTap: () {
              ref.read(attendanceProvider.notifier).markAttendance(
                    widget.selectedDate,
                    volunteer,
                    AttendanceStatus.present,
                  );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.red),
            title: const Text('Absent'),
            onTap: () {
              ref.read(attendanceProvider.notifier).markAttendance(
                    widget.selectedDate,
                    volunteer,
                    AttendanceStatus.absent,
                  );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.orange),
            title: const Text('Deferred'),
            onTap: () {
              ref.read(attendanceProvider.notifier).markAttendance(
                    widget.selectedDate,
                    volunteer,
                    AttendanceStatus.deferred,
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceData = ref.watch(attendanceProvider);

    // filter volunteers by program and name
    final filteredVolunteers = allVolunteers.where((v) {
      final programMatch =
          selectedProgram == null ||
          selectedProgram == 'All' ||
          v.program == selectedProgram;

      final nameMatch =
          v.name.toLowerCase().contains(searchText.toLowerCase());

      return programMatch && nameMatch;
    }).toList();

    return Column(
      children: [
        // program dropdown
        DropdownButtonFormField<String>(
          dropdownColor: Colors.grey,
          hint: const Text('Select Program'),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 208, 208, 208),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          items: programs
              .map(
                (p) => DropdownMenuItem<String>(
                  value: p,
                  child: Text(p),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedProgram = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // search field
        TextField(
          enabled: selectedProgram != null,
          decoration: InputDecoration(
            hintText: 'Search volunteer name',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: const Color.fromARGB(255, 208, 208, 208),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // volunteers list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredVolunteers.length,
          itemBuilder: (context, index) {
            final volunteer = filteredVolunteers[index];
            final status = _getStatus(volunteer, attendanceData);

            Color iconColor = Colors.grey;
            if (status == AttendanceStatus.present) {
              iconColor = Colors.green;
            } else if (status == AttendanceStatus.absent) {
              iconColor = Colors.red;
            } else if (status == AttendanceStatus.deferred) {
              iconColor = Colors.orange;
            }

            return ListTile(
              title: Text(volunteer.name),
              subtitle: Text(volunteer.program),

              // edit attendance button
              trailing: IconButton(
                icon: Icon(Icons.circle, color: iconColor),
                onPressed: () => _showAttendanceOptions(volunteer),
              ),
            );
          },
        ),
      ],
    );
  }
}
