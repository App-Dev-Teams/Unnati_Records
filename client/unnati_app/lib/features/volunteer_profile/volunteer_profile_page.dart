import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/self_attendance_page.dart';
import 'package:unnati_app/features/volunteer_profile/Volunteer_profile_listtile.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({super.key});

  @override
  State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  static const List<String> _programOptions = [
    'DigiXplore',
    'Netritva',
    'Akshar',
  ];
  static const List<String> _branchOptions = ['CSE', 'MAE', 'ECE', 'MNC'];

  String _name = "Priyanshu Kumar";
  String phone = "xxxxxxxxxxxx";
  String batch = "2025";
  String program = "DigiXplore";
  String branch = "CSE";
  Map<String, dynamic>? _user;
  late final StreamSubscription<Map<String, dynamic>?> _userDataSubscription;

  int _parseBatchYear(String value) {
    final match = RegExp(r'(\d{4})').firstMatch(value);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 2025;
    }

    return int.tryParse(value.trim()) ?? 2025;
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _userDataSubscription = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      setState(() {
        _user = user;
        if (user != null) {
          if (user['name'] != null) {
            _name = user['name'].toString();
          }
          if (user['phoneNo'] != null) {
            phone = user['phoneNo'].toString();
          }
          if (user['batch'] != null) {
            batch = user['batch'] is Map<String, dynamic>
                ? '${user['batch']['startYear']}-${user['batch']['endYear']}'
                : user['batch'].toString();
          }
          if (user['program'] != null) {
            program = user['program'].toString();
          }
          if (user['branch'] != null) {
            branch = user['branch'].toString();
          }
        }
      });
    });
  }

  Future<void> _loadUser() async {
    final user = await ApiService.getUserData();
    if (!mounted) return;
    setState(() {
      _user = user;
      if (user != null) {
        _name = user['name']?.toString() ?? _name;
        phone = user['phoneNo']?.toString() ?? phone;
        batch = user['batch'] is Map<String, dynamic>
            ? '${user['batch']['startYear']}-${user['batch']['endYear']}'
            : (user['batch']?.toString() ?? batch);
        program = user['program']?.toString() ?? program;
        branch = user['branch']?.toString() ?? branch;
      }
    });
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    super.dispose();
  }

  // opens dialog to edit profile details
  void _editProfile({
    required String currentName,
    required String currentPhone,
    required String currentBatch,
    required String currentProgram,
    required String currentBranch,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);
    final batchController = TextEditingController(
      text: _parseBatchYear(currentBatch).toString(),
    );

    String selectedProgram = _programOptions.contains(currentProgram)
        ? currentProgram
        : _programOptions.first;
    String selectedBranch = _branchOptions.contains(currentBranch)
        ? currentBranch
        : _branchOptions.first;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(text)) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: batchController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Batch Start Year',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final year = int.tryParse(text);
                      if (text.isEmpty) {
                        return 'Batch year is required';
                      }
                      if (year == null || year < 2000 || year > 2100) {
                        return 'Batch year must be between 2000 and 2100';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedProgram,
                    decoration: const InputDecoration(
                      labelText: 'Program',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    items: _programOptions
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedProgram = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Program is required';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedBranch,
                    decoration: const InputDecoration(
                      labelText: 'Branch',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    items: _branchOptions
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedBranch = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Branch is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }

                final newName = nameController.text.trim();
                final newPhone = phoneController.text.trim();
                final newBatchYear = int.parse(batchController.text.trim());

                final res = await ApiService.updateProfile(
                  name: newName,
                  phoneNo: newPhone,
                  program: selectedProgram,
                  branch: selectedBranch,
                  batchYear: newBatchYear,
                );

                if (res['success'] == true) {
                  setState(() {
                    _name = newName;
                    phone = newPhone;
                    batch = '$newBatchYear-${newBatchYear + 4}';
                    program = selectedProgram;
                    branch = selectedBranch;
                  });
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['message'] ?? 'Update failed'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Clear all stored data
              await ApiService.clearAllData();

              // Navigate to auth check (which will route to login)
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthCheck()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    print("snapshot data in profile page ${user}");

    final name = (user != null && user['name'] != null)
        ? user['name'] as String
        : _name;
    final email = (user != null && user['email'] != null)
        ? user['email'] as String
        : 'abc@iiitbh.ac.in';
    final phoneLocal = (user != null && user['phoneNo'] != null)
        ? user['phoneNo'] as String
        : phone;
    final batchLocal = (user != null && user['batch'] != null)
        ? (user['batch'] is Map<String, dynamic>
              ? '${user['batch']['startYear']}-${user['batch']['endYear']}'
              : user['batch'].toString())
        : batch;
    final roleLocal = (user != null && user['role'] != null)
        ? user['role'] as String
        : 'Volunteer';
    final programLocal = (user != null && user['program'] != null)
        ? user['program'] as String
        : program;
    final branchLocal = (user != null && user['branch'] != null)
        ? user['branch'] as String
        : branch;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        foregroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: true,

        // edit button
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(
              currentName: name,
              currentPhone: phoneLocal,
              currentBatch: batchLocal,
              currentProgram: programLocal,
              currentBranch: branchLocal,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
      
              // avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(backgroundColor: Colors.black, radius: 63),
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/studentSarthi.jpeg',
                    ),
                    radius: 60,
                  ),
                ],
              ),
      
              const SizedBox(height: 10),
      
              // name
              Text(
                name,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
      
              const SizedBox(height: 10),
      
              // VIEW ATTENDANCE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelfAttendancePage(
                        userId: user != null && user['id'] != null
                            ? user['id'].toString()
                            : '',
                      )
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    //padding: const EdgeInsets.all(8),
                    width:double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                        ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.calendar_month,
                              color: Colors.lightBlueAccent,
                              size: 22,
                            ),
                          ),
                         const SizedBox(width: 14),
                                        
                          Expanded(
                            child: Text(
                              'View  Your Attendance',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                                        
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                      ],),
                    ),
                  ),
                ),
              ),
      
              // CONTACT INFORMATION CONTAINER
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Contact Information',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
      
                        VolunteerProfileListtile(
                          title: email,
                          subtitle: 'email',
                          icon: Icons.email,
                          iconColor: Colors.green,
                        ),
      
                        VolunteerProfileListtile(
                          title: phoneLocal,
                          subtitle: 'phone',
                          icon: Icons.phone,
                          iconColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      
              // MORE DETAILS CONTAINER
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'More Details',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
      
                        VolunteerProfileListtile(
                          title: roleLocal,
                          subtitle: 'role',
                          icon: Icons.assignment_ind,
                          iconColor: Colors.white,
                        ),
      
                        VolunteerProfileListtile(
                          title: programLocal,
                          subtitle: 'program',
                          icon: Icons.flag,
                          iconColor: Colors.white,
                        ),
      
                        // VolunteerProfileListtile(
                        //   title: branch,
                        //   subtitle: 'branch',
                        //   icon: Icons.school,
                        //   iconColor: Colors.white,
                        // ),
      
                        VolunteerProfileListtile(
                          title: batchLocal,
                          subtitle: 'batch',
                          icon: Icons.calendar_today,
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      
              // LOGOUT BUTTON
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
