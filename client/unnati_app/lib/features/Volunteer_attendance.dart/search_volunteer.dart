// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/attendance_provider.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_model.dart';

class SearchVolunteer extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const SearchVolunteer({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  ConsumerState<SearchVolunteer> createState() => _SearchVolunteerState();
}

class _SearchVolunteerState extends ConsumerState<SearchVolunteer> {
  String? selectedProgram;
  String searchText = '';

  //programs list
  final List<String> programs = ['DigiXplore', 'Netritva', 'Akshar', 'All'];

  //all volunteers
  final List<Volunteer> allVolunteers = [
    Volunteer(name: 'Rahul Sharma', program: 'DigiXplore'),
    Volunteer(name: 'Priyanshu Kumar', program: 'DigiXplore'),
    Volunteer(name: 'Ankit Verma', program: 'Netritva'),
    Volunteer(name: 'Sneha Singh', program: 'Akshar'),
    Volunteer(name: 'Aman Gupta', program: 'Netritva'),
  ];

  // ===== FIXED =====
  // check for marked present (date normalized)
  bool _isMarkedPresent(
    Volunteer volunteer,
    Map<DateTime, List<Volunteer>> attendanceData,
  ) {
    final normalized = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    final list = attendanceData[normalized] ?? [];
    return list.any((v) => v.name == volunteer.name);
  }

  @override
  Widget build(BuildContext context) {
    final attendanceData = ref.watch(attendanceProvider);

    //filter list
    final filteredVolunteers = allVolunteers.where((volunteer) {
      final matchesProgram =
          selectedProgram == 'All' || volunteer.program == selectedProgram;

      final matchesName = volunteer.name.toLowerCase().contains(
        searchText.toLowerCase(),
      );

      return matchesProgram && matchesName;
    }).toList();

    return Column(
      children: [
        //drop down menu for program
        DropdownButtonFormField(
          dropdownColor: Colors.grey,
          initialValue: selectedProgram,
          hint: const Text('Select Program'),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 208, 208, 208),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          items: programs.map((program) {
            return DropdownMenuItem(value: program, child: Text(program));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedProgram = value;
            });
          },
        ),

        const SizedBox(height: 16),

        //search bar
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

        //filtered list after search
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredVolunteers.length,
          itemBuilder: (context, index) {
            final volunteer = filteredVolunteers[index];
            final isPresent =
                _isMarkedPresent(volunteer, attendanceData);

            return ListTile(
              title: Text(volunteer.name),
              subtitle: Text(volunteer.program),

              trailing: IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: isPresent ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  if (!isPresent) {
                    ref
                        .read(attendanceProvider.notifier)
                        .markPresent(widget.selectedDate, volunteer);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${volunteer.name} marked present',
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
