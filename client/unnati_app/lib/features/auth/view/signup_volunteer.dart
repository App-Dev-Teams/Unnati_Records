import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

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

  File? selectedProfileImage;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> chooseProfilePicture() async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null && mounted) {
      setState(() {
        selectedProfileImage = File(pickedFile.path);
      });
    }
  }

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

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your phone number"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (selectedProgram == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a program"),
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

    // setState(() {
    //   isLoading = false;
    // });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Signup successful'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
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
      if (selectedProfileImage != null) {
        try {
          final imageUrl = await ApiService.uploadProfilePicture(
            selectedProfileImage!,
          );

          final picResult = await ApiService.updateProfilePicture(imageUrl);

          if (picResult['success'] != true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Account created, but profile picture could not be saved. '
                  '${picResult['message'] ?? ''}',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } catch (e) {
          debugPrint('Profile picture upload failed: $e');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created, but photo upload failed. You can add it later.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

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

      if (mounted) {
        setState(() {
          isLoading = false;
        });
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
                  Center(
                child: GestureDetector(
                  onTap: chooseProfilePicture,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 63,
                        backgroundColor: const Color(0xFFE8F1FA),
                        backgroundImage: selectedProfileImage != null
                            ? FileImage(selectedProfileImage!)
                            : null,
                        child: selectedProfileImage == null
                            ? Icon(
                                Icons.person,
                                size: 70,
                                color: const Color.fromARGB(255, 9, 75, 128),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0.5,
                        right: 2,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 9, 75, 128),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
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
              SizedBox(height: 20.h),
              SizedBox(
                width: 300.w,
                child: TextfieldUtil(
                  title: 'Phone Number',
                  controller: phoneController,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: 300.w,
                child: InputDecorator(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 72, 160, 248),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 152, 199, 246),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Select Program',
                    labelStyle: GoogleFonts.oswald(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedProgram,
                    hint: Text(
                      'Select Program',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(
                        value: 'DigiXplore',
                        child: Text('DigiXplore'),
                      ),
                      DropdownMenuItem(value: 'Akshar', child: Text('Akshar')),
                      DropdownMenuItem(
                        value: 'Netritva',
                        child: Text('Netritva'),
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
                    ? const SizedBox(
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
