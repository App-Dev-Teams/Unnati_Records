import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset("assets/lottie/empty.json")),
          Text('No assignments available',style: GoogleFonts.oswald(fontSize: 20,fontWeight: FontWeight.bold),),
        ],
      ),
      ),
    );
  }}