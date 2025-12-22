import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/auth/newpassword.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  const ForgotPasswordOtpPage({super.key});

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(26),
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "OTP Verification",
                style: GoogleFonts.oswald(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "OTP is sent to\n"
                "divyanshu.230101051@iiitbh.ac.in",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              _otpField(),

              //const SizedBox(height: 24),
              Align(alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Resend OTP",
                    style: GoogleFonts.nunito(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 9, 75, 128),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Verify OTP", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpField() {
    return TextField(
      controller: otpController,
      maxLength: 5,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        letterSpacing: 12,
        color: Colors.white,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: const Color.fromARGB(255, 14, 22, 33),
        hintText: "-----",
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _verifyOtp() {
    if (otpController.text.length != 5) {// Replace krna h ye condition while integrating backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong OTP, please re-enter"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("OTP Verified"),
        backgroundColor: Colors.green,
      ),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResetPasswordPage(),
      ),
    );
  });
}
   
  }

