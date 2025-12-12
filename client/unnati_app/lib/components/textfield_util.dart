import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldUtil extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  const TextfieldUtil({super.key, required this.title, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 72, 160, 248),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 152, 199, 246)),
        ),
        labelText: title,
        labelStyle: GoogleFonts.oswald(color:  Colors.black.withOpacity(0.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
