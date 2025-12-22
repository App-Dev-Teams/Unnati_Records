import 'package:flutter/material.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';

class PdfAssignments extends StatefulWidget {
  const PdfAssignments({super.key});

  @override
  _PdfAssignmentsState createState() => _PdfAssignmentsState();
  }
  
class _PdfAssignmentsState extends State<PdfAssignments> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdfAppBar(imageName: "unnatiLogoColourFix.png", name: "Assignments"),
      body: Center(
        child: Text("Stay Tuned for quizzes and assignments!!"),
      ),
    );
  }}