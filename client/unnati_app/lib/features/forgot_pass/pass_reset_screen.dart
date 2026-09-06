import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/features/auth/view/login_page_volunteer.dart';
import 'package:unnati_app/services/api_service.dart';

class PasswordResetScreen extends StatefulWidget {
  final String email;

  const PasswordResetScreen({super.key, required this.email});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController checkNewPasswordController = TextEditingController();
  bool _isUpdating = false;
  bool _obsecureText = true;
  bool _ConfirmObsecureText = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    checkNewPasswordController.dispose();
    super.dispose();
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
                  obscureText: _obsecureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        _obsecureText = !_obsecureText;
                      });
                    }, icon: Icon(
                      
                      (_obsecureText) ?
                      Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      )),
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
                  obscureText: _ConfirmObsecureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        _ConfirmObsecureText = !_ConfirmObsecureText;
                      });
                    }, icon: Icon(
                      
                      (_ConfirmObsecureText) ?
                      Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      )),
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
                  onPressed: _isUpdating
                      ? null
                      : () async {
                          final newPassword = newPasswordController.text.trim();
                          final confirmPassword = checkNewPasswordController
                              .text
                              .trim();

                          if (newPassword.isEmpty || confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill both password fields',
                                ),
                              ),
                            );
                            return;
                          }

                          if (newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _isUpdating = true;
                          });

                          final response = await ApiService.updatePassword(
                            email: widget.email,
                            newPassword: newPassword,
                          );

                          setState(() {
                            _isUpdating = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message'] as String),
                            ),
                          );

                          if (response['success'] == true) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPageVolunteer(),
                              ),
                              (route) => false,
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
