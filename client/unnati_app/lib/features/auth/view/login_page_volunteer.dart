import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';

class LoginPageVolunteer extends StatefulWidget {
  const LoginPageVolunteer({super.key});

  @override
  State<LoginPageVolunteer> createState() => _LoginPageVolunteerState();
}

class _LoginPageVolunteerState extends State<LoginPageVolunteer> {

  //controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

//validation of email
  bool isValidVolunteerEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z]+\.([0-9]+)@iiitbh\.ac\.in$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),//app bar
      body: SingleChildScrollView(//body
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 30.h, width: double.infinity),
              //lottie
              Lottie.asset(
                'assets/lottie/Login_and_Signup.json',
                height: 300.h,
                width: 300.w,
              ),
              //mid heading
              SizedBox(height: 10.h, width: double.infinity),
              Text(
                'Volunteer',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 30.sp,
                  color: const Color.fromARGB(255, 9, 75, 128),
                ),
              ),
              SizedBox(height: 10.h, width: double.infinity),
              //textfields
              SizedBox(
                width: 300.w,
                child: TextfieldUtil(//email textfield
                  title: 'xxxxx.123@iiitbh.ac.in',
                  controller: emailController,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: 300.w,
                child: TextfieldUtil( //password textfield
                  title: 'Password',
                  controller: passwordController,
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(//login button
                onPressed: () {
                  final email = emailController.text.trim();
                  if (!isValidVolunteerEmail(email)) { //validation and snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter a valid IIITBH email"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  print("logged in as a volunteer");
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
