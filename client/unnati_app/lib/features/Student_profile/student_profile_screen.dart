import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/volunteer_profile/Volunteer_profile_listtile.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

class StudedntProfileScreen extends StatefulWidget {
  const StudedntProfileScreen({super.key});

  @override
  State<StudedntProfileScreen> createState() => _StudedntProfileScreenState();
}

class _StudedntProfileScreenState extends State<StudedntProfileScreen> {
  String _name = "Student";
  String phone = "xxxxxxxxxxxx";
  String studentClass = "10";
  String school = "School Name";
  List<String> schools = [];
  List<int> selectClass = [5, 6, 7, 8, 9, 10, 11, 12];

  @override
  void initState() {
    super.initState();
    _fetchSchools();
  }

  void _fetchSchools() async {
    final fetchedSchools = await ApiService.getSchools();
    if (!mounted) return;
    setState(() {
      schools = fetchedSchools;
    });
  }

  // opens dialog to edit profile details
  void _editProfile({
    required String currentName,
    required String currentPhone,
    required String currentClass,
    required String currentSchool,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);
    int? selectedClass = int.tryParse(currentClass);

    // Ensure selectedSchool is in the schools list, otherwise set to first available or current value.
    String? selectedSchool = schools.contains(currentSchool)
        ? currentSchool
        : (schools.isNotEmpty ? schools.first : null);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFFF5F5F5),
          surfaceTintColor: Colors.transparent,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),

          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF061A22),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Update your personal information',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 14),
              Divider(
                color: Color(0xFF29B6F6),
                thickness: 3,
                height: 3,
                endIndent: 180,
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<int>(
                    value: selectedClass,
                    decoration: InputDecoration(
                      labelText: 'Class',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: const Icon(
                        Icons.school_outlined,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    items: selectClass.map((cls) {
                      return DropdownMenuItem<int>(
                        value: cls,
                        child: Text(cls.toString()),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Class is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setDialogState(() {
                        selectedClass = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedSchool,
                    decoration: InputDecoration(
                      labelText: 'School',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: const Icon(
                        Icons.apartment_rounded,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    items: schools.map((s) {
                      return DropdownMenuItem<String>(
                        value: s,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                s,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'School is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setDialogState(() {
                        selectedSchool = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF29B6F6),
                  foregroundColor: const Color(0xFF061A22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  if (!(formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  final newName = nameController.text.trim();
                  final newPhone = phoneController.text.trim();
                  final newClass = selectedClass?.toString() ?? currentClass;
                  final newSchool = selectedSchool ?? currentSchool;

                  final res = await ApiService.updateProfile(
                    name: newName,
                    phoneNo: newPhone,
                    studentClass: newClass,
                    school: newSchool,
                  );

                  if (!mounted) return;

                  if (res['success'] == true) {
                    final updated = res['data'] as Map<String, dynamic>?;

                    final updatedName = updated?['name']?.toString() ?? newName;
                    final updatedPhone =
                        updated?['phoneNo']?.toString() ?? newPhone;
                    final updatedClass =
                        updated?['studentClass']?.toString() ?? newClass;
                    final updatedSchool =
                        updated?['school']?.toString() ?? newSchool;

                    setState(() {
                      _name = updatedName;
                      phone = updatedPhone;
                      studentClass = updatedClass;
                      school = updatedSchool;
                    });

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['message'] ?? 'Update failed'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Color(0xFF061A22),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
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
    backgroundColor: const Color(0xFFF5F5F5),
    surfaceTintColor: Colors.transparent,
    elevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
    contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
    actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),

    title: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: Color(0xFF147DAD),
              size: 27,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Confirm Logout',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF061A22),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Divider(
          color: Color(0xFF29B6F6),
          thickness: 3,
          height: 3,
          endIndent: 180,
        ),
      ],
    ),

    content: const Text(
      'Are you sure you want to logout?',
      style: TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Color(0xFF52616B),
        fontWeight: FontWeight.w500,
      ),
    ),

    actions: [
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF061A22),
                side: const BorderSide(
                  color: Color(0xFFD5DEE3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF29B6F6),
                foregroundColor: const Color(0xFF061A22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                Navigator.pop(context);

                // Clear all stored data
                await ApiService.clearAllData();

                // Navigate to auth check (which will route to login)
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthCheck(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiService.getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        final name = (user != null && user['name'] != null)
            ? user['name'] as String
            : _name;
        final email = (user != null && user['email'] != null)
            ? user['email'] as String
            : 'abc@example.com';
        final phoneLocal = (user != null && user['phoneNo'] != null)
            ? user['phoneNo'] as String
            : phone;
        final classLocal = (user != null && user['studentClass'] != null)
            ? user['studentClass'] as String
            : studentClass;
        final schoolLocal = (user != null && user['school'] != null)
            ? user['school'] as String
            : school;
        final roleLocal = (user != null && user['role'] != null)
            ? user['role'] as String
            : 'Student';

        return Scaffold(
          backgroundColor: Colors.white,

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
                  currentClass: classLocal,
                  currentSchool: schoolLocal,
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
                      const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 63,
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/unnatiLogoColourFix.png',
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
                              title: classLocal,
                              subtitle: 'class',
                              icon: Icons.school,
                              iconColor: Colors.white,
                            ),

                            VolunteerProfileListtile(
                              title: schoolLocal,
                              subtitle: 'school',
                              icon: Icons.location_city,
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
      },
    );
  }
}
