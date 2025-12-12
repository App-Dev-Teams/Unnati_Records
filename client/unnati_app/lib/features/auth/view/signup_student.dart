import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';

class SignupStudent extends StatefulWidget {
  SignupStudent({super.key});

  @override
  State<SignupStudent> createState() => _SignupStudentState();
}

class _SignupStudentState extends State<SignupStudent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/Login_and_Signup.json',
                height: 300.h,
                width: 300.w,
              ),
              SizedBox(height: 10.h, width: double.infinity),
              Text(
                'Student',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 30.sp,
                  color: const Color.fromARGB(255, 9, 75, 128),
                ),
              ),
              SizedBox(height: 10.h, width: double.infinity),

              SizedBox(
                width: 300.w,
                child: TextfieldUtil(
                  title: 'Username',
                  controller: usernameController,
                ),
              ),
              SizedBox(height: 20.h),

              SizedBox(
                width: 300.w,
                child: TextfieldUtil(
                  title: 'Email',
                  controller: emailController,
                ),
              ),
              SizedBox(height: 20.h),

              SizedBox(
                width: 300.w,
                child: TextfieldUtil(
                  title: 'Password',
                  controller: passwordController,
                ),
              ),
              SizedBox(height: 30.h),

              ElevatedButton(
                onPressed: () {
                  print("signed up as a student -> ${usernameController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                  padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  'Sign Up',
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
