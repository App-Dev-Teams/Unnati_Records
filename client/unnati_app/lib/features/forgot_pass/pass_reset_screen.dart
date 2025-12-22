import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  TextEditingController newPasswordController = TextEditingController(); 
  TextEditingController checkNewPasswordController = TextEditingController(); 

  @override
  void dispose() {
    super.dispose();
    newPasswordController.dispose();
    checkNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                //lottie
                child: Container(
                  height: 200.h,
                  width: 200.w,
                  child: Lottie.asset('assets/lottie/reset_pass_lottie.json'),
                ),
              ),
              SizedBox(height: 100),

              //textfield of pass change
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    label: Text('Enter new password'),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: TextField(
                  controller: checkNewPasswordController,
                  decoration: InputDecoration(
                    label: Text('Re-enter new password'),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              //button
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // fixedSize: Size(300.w, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                  ),
                  onPressed: () {
                    if (newPasswordController.text ==
                        checkNewPasswordController.text) {
                      //next logic
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                    }
                  },
                  child: Center(
                    child: Text(
                      'Change Password',
                      style: GoogleFonts.cormorantSc(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
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
