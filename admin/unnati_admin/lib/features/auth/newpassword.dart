import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/admin_homescreen.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  bool showNew = false;
  bool showConfirm = false;

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
                "Reset Password",
                style: GoogleFonts.oswald(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              _passwordField(
                controller: newPassCtrl,
                label: "Create New Password",
                show: showNew,
                toggle: () {
                  setState(() => showNew = !showNew);
                },
              ),

              const SizedBox(height: 18),

              _passwordField(
                controller: confirmPassCtrl,
                label: "Confirm New Password",
                show: showConfirm,
                toggle: () {
                  setState(() => showConfirm = !showConfirm);
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    isbothsame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 9, 75, 128),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Update Password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool show,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !show,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color.fromARGB(255, 14, 22, 33),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  void isbothsame(){
  if(newPassCtrl.text != confirmPassCtrl.text || newPassCtrl.text.isEmpty || confirmPassCtrl.text.isEmpty){
    ScaffoldMessenger.of(context).  showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match"),
        backgroundColor: Colors.red,
      ),
    );
  }
  else{ 
  ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password Updated Successfully"),
            backgroundColor: Colors.green,
                      ),
                    );}
                  Future.delayed(const Duration(milliseconds: 800), () {
                    Navigator.push(context, MaterialPageRoute(builder:  (_) =>  AdminHomePage(),));
                  });
    
  
}}