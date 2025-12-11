import 'package:flutter/material.dart';
import 'signup.dart';
void main() {
  runApp(const UnnatiApp());
}

class UnnatiApp extends StatelessWidget {
  const UnnatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unnati Records',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: SignUp(),
    );
  }
}

