import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class SignUpVolunteer extends StatefulWidget {
  const SignUpVolunteer({super.key});

  @override
  State<SignUpVolunteer> createState() => _SignUpVolunteerState();
}

class _SignUpVolunteerState extends State<SignUpVolunteer> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedProgram;
  bool isLoading = false;

  bool isValidVolunteerEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9]+\.([0-9]+)@iiitbh\.ac\.in$');
    return regex.hasMatch(email);
  }

  Future<void> handleSignup() async {
    final name = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseenteryourname),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (name.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.namemustbeatleast3characters,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!isValidVolunteerEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pleaseenteravalidiIITBHemail,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseenterapassword),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.passwordmustbeatleast6characters,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pleaseenteryourphonenumber,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (selectedProgram == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseselectaprogram),
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
      program: selectedProgram!,
      phoneNo: phone,
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
          duration: Duration(seconds: 2),
        ),
      );
      // Save role if returned by server (defensive)
      try {
        final data = result['data'] as Map<String, dynamic>?;
        final role = data != null ? data['role'] as String? : null;
        if (role != null && role.isNotEmpty) {
          await ApiService.saveRole(role);
        }
        if (data != null) {
          print(data);
          await ApiService.saveUserData(data);
        }
      } catch (e) {
        // ignore
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AuthCheck()),
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
          duration: Duration(seconds: 3),
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
                AppLocalizations.of(context)!.volunteer,
                style: GoogleFonts.luckiestGuy(
                  fontSize: 30.sp,
                  color: Color.fromARGB(255, 9, 75, 128),
                ),
              ),
              SizedBox(height: 10.h, width: double.infinity),
              SizedBox(
                width: 300.w,
                child: TextfieldUtil(
                  title: AppLocalizations.of(context)!.username,
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
                  title: AppLocalizations.of(context)!.password,
                  controller: passwordController,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: 300.w,
                child: TextfieldUtil(
                  title: AppLocalizations.of(context)!.phonenumber,
                  controller: phoneController,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: 300.w,
                child: InputDecorator(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 72, 160, 248),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 152, 199, 246),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: AppLocalizations.of(context)!.selectprogram,
                    labelStyle: GoogleFonts.oswald(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedProgram,
                    hint: Text(
                      AppLocalizations.of(context)!.selectprogram,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    isExpanded: true,
                    underline: SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(
                        value: 'DigiXplore',
                        child: Text(AppLocalizations.of(context)!.digiXplore),
                      ),
                      DropdownMenuItem(
                        value: 'Akshar',
                        child: Text(AppLocalizations.of(context)!.akshar),
                      ),
                      DropdownMenuItem(
                        value: 'Netritva',
                        child: Text(AppLocalizations.of(context)!.netritva),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedProgram = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: isLoading ? null : handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 9, 75, 128),
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.w,
                    vertical: 15.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.signup,
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
