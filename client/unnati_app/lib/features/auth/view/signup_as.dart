import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/features/auth/view/login_page_student.dart';
import 'package:unnati_app/features/auth/view/login_page_volunteer.dart';
import 'package:unnati_app/features/auth/view/signup_as.dart';
import 'package:unnati_app/features/auth/view/signup_student.dart';
import 'package:unnati_app/features/auth/view/signup_volunteer.dart';

class SignupAs extends StatefulWidget {
  const SignupAs({super.key});

  @override
  State<SignupAs> createState() => _SignupAsState();
}

class _SignupAsState extends State<SignupAs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Scaffold backgroud color
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70.h,),
            //unnati logo
            Image.asset(
              'assets/images/unnatiLogoColourFix.png',
              height: 150.h,
              width: 150.w,
            ),
            SizedBox(height: 50.h, width: double.infinity),
            //lottie
            Lottie.asset(
              'assets/lottie/student.json',
              height: 200.h,
              width: 200.w,
            ),
            SizedBox(height: 70.h, width: double.infinity),
        
            //options
            Container(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  //you are?
                  Center(
                    child: Text(
                      'Sign Up As ',
                      style: GoogleFonts.oswald(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h, width: double.infinity),
        
                  //volunteer
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200.w, 60.h), /////
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
                  //student
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200.w, 60.h), /////
                      backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupStudent(),
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
           
          ],
        ),
      ),
    );
  }
}
