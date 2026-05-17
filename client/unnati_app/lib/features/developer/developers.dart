import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/developer/developer_cards.dart';

class DevelopersPage extends StatelessWidget {
  const DevelopersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                " MEET OUR DEVELOPERS",
                style: GoogleFonts.oswald(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              //mentor
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 22.h,
                      width: 5.h,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Mentor",
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 2),
              DeveloperCards(
                color: Colors.lightGreenAccent,
                name: "Divyanshu Pal",
                devRole: "Mentor",
                desc:
                    "Flutter developer, hackathon achiever, and mentor of our developer team who continuously inspired and guided us in building impactful projects.",
                linkedInurl: "https://www.linkedin.com/in/divyaanshu/",
              ),
              SizedBox(height: 30),

              //backend
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 22.h,
                      width: 5.h,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Backend Developers",
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              DeveloperCards(
                color: Colors.lightBlueAccent,
                name: "Ishani Karpoor",
                devRole: "Backend Developer",
                desc:
                    "Passionate app developer and App Coordinator at Unnati Welfare Society, dedicated to building impactful digital solutions for students and volunteers.",
                linkedInurl:
                    "https://www.linkedin.com/in/ishani-karpoor-8a73b1312",
              ),
              DeveloperCards(
                color: Colors.lightBlueAccent,
                name: "Shreyas Prajapati",
                devRole: "Backend Integration",
                desc:
                    "A creative developer passionate about app development, game design, and building impactful digital solutions through technology and innovation.",
                linkedInurl:
                    "https://www.linkedin.com/in/shreyas-prajapati-116231325/",
              ),
              SizedBox(height: 30),

              //frontend
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 22.h,
                      width: 5.h,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Frontend Developers",
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              DeveloperCards(
                name: "Priyanshu Kumar",
                devRole: "Frontend Developer",
                desc:
                    "A dedicated developer with interests in Flutter, UI/UX, and problem solving, constantly learning and building innovative solutions through technology.",
                linkedInurl:
                    "https://www.linkedin.com/in/priyanshu-kumar-899b91324/",
                color: Colors.deepOrangeAccent,
              ),
              DeveloperCards(
                name: "Utkarsh Rastogi",
                devRole: "Frontend Developer",
                desc:
                    "Full-stack and Flutter developer passionate about building scalable applications, solving complex problems, and creating impactful digital solutions through technology and innovation.",
                linkedInurl: "https://www.linkedin.com/in/utkarsh-rastogi-8b1bb0317/",
                color: Colors.deepOrangeAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
