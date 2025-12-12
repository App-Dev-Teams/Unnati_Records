import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';

class LoginPageStudent extends StatefulWidget {
  const LoginPageStudent({super.key});

  @override
  State<LoginPageStudent> createState() => _LoginPageStudentState();
}

class _LoginPageStudentState extends State<LoginPageStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),//app bar
      body: SingleChildScrollView(//body
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 50.h, width: double.infinity),
              Lottie.asset( //lottie
                'assets/lottie/Login_and_Signup.json',
                height: 300.h,
                width: 300.h,
              ),
              SizedBox(height: 10.h, width: double.infinity),
              Text( //mid heading
                'Student',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 30.sp,
                  color: const Color.fromARGB(255, 9, 75, 128),
                ),
              ),
              SizedBox(height: 10.h, width: double.infinity),
              SizedBox(//textfields
                width: 300.w,
                child: TextfieldUtil(title: 'Email'), //email textfield
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: 300.w,
                child: TextfieldUtil(title: 'Password'), //password textfield
              ),
              SizedBox(height: 30.h),
              ElevatedButton( //login button
                onPressed: () {print("Logged in as a student");
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> VolunteerHomePage   ))
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:  Text(
                  'Login',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
