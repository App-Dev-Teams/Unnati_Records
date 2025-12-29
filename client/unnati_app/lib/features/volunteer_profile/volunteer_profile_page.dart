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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 12, 19),
        foregroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        // centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    radius: 63,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/unnatiLogoColourFix.png',
                    ),
                    radius: 60,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                _name,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
//contact information container
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                        //contact information listtiles
                        VolunteerProfileListtile(title: 'abc@iiitbh.ac.in', subtitle: 'email', icon: Icons.email, iconColor: Colors.green),
                        VolunteerProfileListtile(title: 'xxxxxxxxxxxx', subtitle: 'phone', icon: Icons.phone, iconColor: Colors.green),

                      ],
                    ),
                  ),
                ),
              ),

              //More Details container
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                        //more information listtiles
                         VolunteerProfileListtile(title: 'Volunteer', subtitle: 'role', icon: Icons.assignment_ind, iconColor: Colors.white),
                        VolunteerProfileListtile(title: 'DigiXplore', subtitle: 'program', icon: Icons.flag, iconColor: Colors.white),
                        VolunteerProfileListtile(title: 'CSE', subtitle: 'branch', icon: Icons.school, iconColor: Colors.white),
                        VolunteerProfileListtile(title: '2025', subtitle: 'batch', icon: Icons.calendar_today, iconColor: Colors.white),

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
