import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/admin_homescreen.dart';
import 'package:unnati_admin/features/auth/forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 700;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: isDesktop ? 420 : double.infinity,
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
                      "Welcome Back",
                      style: GoogleFonts.oswald(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Login to continue",
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 32),

                    _inputField(
                      controller: emailCtrl,
                      label: "Email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder:  (_) => const ForgotPasswordOtpPage(),));},
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.nunito(
                            color: const Color.fromARGB(255, 140, 200, 255),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if(passwordCtrl.text.isEmpty || emailCtrl.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter email and password"),
                              ),
                            );
                            return;
                          }
                          else if(emailCtrl.text != "divyanshu.230101051@iiitbh.ac.in" ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("You do not have admin access"),
                              ),
                            );
                            return;
                          }
                         
                          else {Navigator.push(context, MaterialPageRoute(builder:  (_) => const AdminHomePage(),));}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 9, 75, 128),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
