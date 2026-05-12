import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/admin_homescreen.dart';
import 'package:unnati_admin/features/auth/login_page.dart';
import 'package:unnati_admin/services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final TextEditingController startYearCtrl = TextEditingController();
  final TextEditingController endYearCtrl = TextEditingController();
  final TextEditingController rollNoCtrl = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    startYearCtrl.dispose();
    endYearCtrl.dispose();
    rollNoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 700;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Image.asset(
                      'assets/images/unnatiLogoColourFix.png',
                      height: isDesktop ? 120 : 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: isDesktop ? 500 : double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 24),
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF111212),
                          Color(0xFF1E2A3A),
                          Color(0xFF2B3D54),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 22,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Admin Sign Up",
                          style: GoogleFonts.oswald(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Create your admin account",
                          style: GoogleFonts.nunito(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _inputField(
                          controller: nameCtrl,
                          label: "Full Name",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          controller: emailCtrl,
                          label: "Email",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          controller: passwordCtrl,
                          label: "Password",
                          icon: Icons.lock_outline,
                          obscure: !showPassword,
                          suffix: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          controller: confirmPasswordCtrl,
                          label: "Confirm Password",
                          icon: Icons.lock_outline,
                          obscure: !showConfirmPassword,
                          suffix: IconButton(
                            icon: Icon(
                              showConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _inputField(
                                controller: startYearCtrl,
                                label: "Start Year",
                                icon: Icons.calendar_today_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _inputField(
                                controller: endYearCtrl,
                                label: "End Year",
                                icon: Icons.calendar_today_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          controller: rollNoCtrl,
                          label: "Roll No (optional)",
                          icon: Icons.numbers,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => _handleSignup(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 9, 75, 128),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    "Sign Up",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: GoogleFonts.nunito(
                                color: Colors.white70,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.nunito(
                                  color:
                                      const Color.fromARGB(255, 140, 200, 255),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        confirmPasswordCtrl.text.isEmpty ||
        startYearCtrl.text.isEmpty ||
        endYearCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (passwordCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final startYear = int.tryParse(startYearCtrl.text);
    final endYear = int.tryParse(endYearCtrl.text);
    final rollNo = rollNoCtrl.text.isEmpty ? null : int.tryParse(rollNoCtrl.text);

    if (startYear == null || endYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid years")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await AdminApiService.signup(
      nameCtrl.text,
      emailCtrl.text,
      passwordCtrl.text,
      startYear,
      endYear,
      rollNo,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup successful! Logging in..."),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminHomePage()),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Signup failed')),
      );
    }
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color.fromARGB(255, 14, 22, 33),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
