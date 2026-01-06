import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/volunteer_profile/Volunteer_profile_listtile.dart';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({super.key});

  @override
  State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  String _name = "Priyanshu Kumar";
  String phone = "xxxxxxxxxxxx";
  String batch = "2025";
  String program = "DigiXplore";
  String branch = "CSE";

  // opens dialog to edit profile details
  void _editProfile() {
    final phoneController = TextEditingController(text: phone);
    final batchController = TextEditingController(text: batch);
    final programController = TextEditingController(text: program);
    final branchController = TextEditingController(text: branch);

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
                decoration: const InputDecoration(labelText: 'Phone',labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: batchController,
                decoration: const InputDecoration(labelText: 'Batch',labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: programController,
                decoration: const InputDecoration(labelText: 'Program',labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: branchController,
                decoration: const InputDecoration(labelText: 'Branch',labelStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                batch = batchController.text;
                program = programController.text;
                branch = branchController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: AppBar(
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
            onPressed: _editProfile,
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
                _name,
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
                          title: 'abc@iiitbh.ac.in',
                          subtitle: 'email',
                          icon: Icons.email,
                          iconColor: Colors.green,
                        ),

                        VolunteerProfileListtile(
                          title: phone,
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
                          title: 'Volunteer',
                          subtitle: 'role',
                          icon: Icons.assignment_ind,
                          iconColor: Colors.white,
                        ),

                        VolunteerProfileListtile(
                          title: program,
                          subtitle: 'program',
                          icon: Icons.flag,
                          iconColor: Colors.white,
                        ),

                        VolunteerProfileListtile(
                          title: branch,
                          subtitle: 'branch',
                          icon: Icons.school,
                          iconColor: Colors.white,
                        ),

                        VolunteerProfileListtile(
                          title: batch,
                          subtitle: 'batch',
                          icon: Icons.calendar_today,
                          iconColor: Colors.white,
                        ),
                      ],
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
