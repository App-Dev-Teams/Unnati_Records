import 'package:flutter/material.dart';
import 'package:unnati_admin/features/admin_homescreen.dart';
import 'package:unnati_admin/features/auth/login_page.dart';
import 'package:unnati_admin/services/api_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _authCheck;

  @override
  void initState() {
    super.initState();
    _authCheck = AdminApiService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 9, 12, 19),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 9, 12, 19),
            body: const Center(
              child: Text('Error checking auth status'),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const AdminHomePage() : const LoginPage();
      },
    );
  }
}
