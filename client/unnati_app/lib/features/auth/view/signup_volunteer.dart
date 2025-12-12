import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';

class SignUpVolunteer extends StatefulWidget {
  SignUpVolunteer({super.key});

  @override
  State<SignUpVolunteer> createState() => _SignUpVolunteerState();
}

class _SignUpVolunteerState extends State<SignUpVolunteer> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isValidVolunteerEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z]+\.([0-9]+)@iiitbh\.ac\.in$');
    return regex.hasMatch(email);
  }

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
                'Volunteer',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 30.sp,
                  color: Color.fromARGB(255, 9, 75, 128),
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
                  title: 'xxxxx.123@iiitbh.ac.in',
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
                  final email = emailController.text.trim();
                  if (!isValidVolunteerEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter a valid IIITBH email"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  print("signed up as a volunteer");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 9, 75, 128),
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
