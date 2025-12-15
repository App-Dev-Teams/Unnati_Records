import 'package:flutter/material.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';

class PdfQuizzes extends StatefulWidget {
  @override
  _PdfQuizzesState createState() => _PdfQuizzesState();
  }
  
class _PdfQuizzesState extends State<PdfQuizzes> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdfAppBar(imageName: "unnatiLogoColourFix.png", name: "Quizzes & Assignments"),
      body: Center(
        child: Text("Stay Tuned for quizzes and assignments!!"),
      ),
    );
  }}