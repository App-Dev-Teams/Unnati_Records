import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:unnati_app/components/pdf_components/pdf_navbar.dart';
import 'package:unnati_app/features/auth/view/login_page_1.dart';
import 'package:unnati_app/features/auth/view/login_page_student.dart';
import 'package:unnati_app/features/Student_Home/student_home_screen.dart';
import 'package:unnati_app/features/auth/view/signup_as.dart';
import 'package:unnati_app/features/forgot_pass/email_verification.dart';
import 'package:unnati_app/features/forgot_pass/pass_reset_screen.dart';
import 'package:unnati_app/features/pdf_feature/pdf_digiexplore.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mainscreen.dart';
import 'package:unnati_app/features/volunteer_home/volunteer_home_screen.dart';
import 'package:unnati_app/features/volunteer_resources/volunteer_resources_page.dart';

void main() {
  runApp(const ProviderScope(child: ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //screen responsiveness
      designSize: Size(360.0, 800.0),
      minTextAdapt: true,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // title: 'Flutter Demo',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // ),
        home: VolunteerHomeScreen(),
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPageStudent()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage1()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
