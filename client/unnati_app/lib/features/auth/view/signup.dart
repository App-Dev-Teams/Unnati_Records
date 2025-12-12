import 'package:flutter/material.dart';
import 'package:unnati_app/theme/colors.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: C.blue),
    );

    return Scaffold(
      backgroundColor: C.white,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: C.blue,
        foregroundColor: C.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/unnatilogo.jpeg', width: 80, height: 80,),
                  SizedBox(height: 20),
                  Lottie.asset(
                    'assets/lottie/signup.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: C.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: C.black),
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                      style: TextStyle(color: C.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: C.black),
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                      style: TextStyle(color: C.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: passCtrl,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: C.black),
                        border: inputBorder,
                        focusedBorder: inputBorder,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: C.black,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: C.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: C.blue,
                        foregroundColor: C.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
