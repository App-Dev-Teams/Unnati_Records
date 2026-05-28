import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unnati_app/services/api_service.dart';
//import 'package:unnati_app/components/pdf_components/pdf_navbar.dart';
import 'package:unnati_app/features/auth/view/login_page_1.dart';
import 'package:unnati_app/features/Student_Home/student_home_screen.dart';
import 'package:unnati_app/features/volunteer_home/volunteer_home_screen.dart';

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
        home: const AuthCheck(),
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
    final token = await ApiService.getToken();
    String? role = await ApiService.getRole();

    // Re-broadcast stored user data on startup so UI can react to current role
    try {
      final storedUser = await ApiService.getUserData();
      if (storedUser != null) {
        await ApiService.saveUserData(storedUser);
      }
    } catch (_) {}

    if ((role == null || role.isEmpty)) {
      try {
        final user = await ApiService.getUserData();
        if (user != null) {
          if (user.containsKey('role') && (user['role'] as String).isNotEmpty) {
            role = user['role'] as String;
          } else if (user.containsKey('studentClass') ||
              user.containsKey('studentClass')) {
            role = 'student';
          } else if (user.containsKey('rollNo') || user.containsKey('batch')) {
            role = 'volunteer';
          }
        }
      } catch (e) {
        // ignore
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      if (role == 'volunteer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VolunteerHomeScreen()),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
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
