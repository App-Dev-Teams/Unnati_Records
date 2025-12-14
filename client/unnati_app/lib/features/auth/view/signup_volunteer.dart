import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

class SignUpVolunteer extends StatefulWidget {
  SignUpVolunteer({super.key});

  @override
  State<SignUpVolunteer> createState() => _SignUpVolunteerState();
}

class _SignUpVolunteerState extends State<SignUpVolunteer> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  bool isValidVolunteerEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z]+\.([0-9]+)@iiitbh\.ac\.in$');
    return regex.hasMatch(email);
  }

  Future<void> handleSignup() async {
    final name = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your name"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (name.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name must be at least 3 characters"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!isValidVolunteerEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid IIITBH email"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a password"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.signup(
      name: name,
      email: email,
      password: password,
      role: 'volunteer',
    );

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Signup successful'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      // Automatically login after signup - navigate to home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthCheck()),
        (route) => false, // Remove all previous routes
      );
    } else {
      String errorMessage = result['message'] ?? 'Signup failed';
      
      if (result['errors'] != null) {
        final errors = result['errors'] as List;
        if (errors.isNotEmpty) {
          errorMessage = errors[0]['msg'] ?? errorMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
                onPressed: isLoading ? null : handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 9, 75, 128),
                  padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
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
