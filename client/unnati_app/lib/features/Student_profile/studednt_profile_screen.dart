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

  // opens dialog to edit profile details
  void _editProfile() {
    final phoneController = TextEditingController(text: phone);
    final classController = TextEditingController(text: studentClass);
    final schoolController = TextEditingController(text: school);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: classController,
                decoration: const InputDecoration(
                  labelText: 'Class',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: schoolController,
                decoration: const InputDecoration(
                  labelText: 'School',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                phone = phoneController.text;
                studentClass = classController.text;
                school = schoolController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
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
          backgroundColor:  Colors.white,

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
              IconButton(icon: const Icon(Icons.edit), onPressed: _editProfile),
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
