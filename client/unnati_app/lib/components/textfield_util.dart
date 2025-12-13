import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldUtil extends StatefulWidget {
  final String title;
  final TextEditingController? controller;
  final bool obscureText;
  
  const TextfieldUtil({
    super.key,
    required this.title,
    this.controller,
    this.obscureText = false,
  });

  @override
  State<TextfieldUtil> createState() => _TextfieldUtilState();
}

class _TextfieldUtilState extends State<TextfieldUtil> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.title.toLowerCase().contains('password');
    
    return TextField(
      controller: widget.controller,
      keyboardType: isPassword 
          ? TextInputType.visiblePassword 
          : TextInputType.emailAddress,
      obscureText: isPassword ? _obscureText : widget.obscureText,
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
        labelText: widget.title,
        labelStyle: GoogleFonts.oswald(color: Colors.black.withOpacity(0.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black.withOpacity(0.5),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
