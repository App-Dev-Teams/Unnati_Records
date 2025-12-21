import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/features/auth/view/login_page_student.dart';
import 'package:unnati_app/features/auth/view/signup_as.dart';
import 'package:unnati_app/features/auth/view/signup_volunteer.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70.h),
            Image.asset(
              'assets/images/unnatiLogoColourFix.png',
              height: 150.h,
              width: 150.w,
            ),
            SizedBox(height: 50.h, width: double.infinity),
            Lottie.asset(
              'assets/lottie/two-people-thinking.json',
              height: 200.h,
              width: 200.w,
            ),
            SizedBox(height: 70.h, width: double.infinity),

            Container(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      'You are ?',
                      style: GoogleFonts.oswald(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h, width: double.infinity),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200.w, 60.h),
                      backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpVolunteer(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Volunteer',
                        style: GoogleFonts.cormorantSc(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h, width: double.infinity),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200.w, 60.h),
                      backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPageStudent(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Student',
                        style: GoogleFonts.cormorantSc(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupAs()),
                );
              },
              child: Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
