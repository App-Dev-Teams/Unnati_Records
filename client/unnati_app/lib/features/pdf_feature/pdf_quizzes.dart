import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class PdfQuizzes extends StatefulWidget {
  const PdfQuizzes({super.key});

  @override
  _PdfQuizzesState createState() => _PdfQuizzesState();
}

class _PdfQuizzesState extends State<PdfQuizzes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdfAppBar(
        imageName: "unnatiLogoColourFix.png",
        name: "Quizzes & Assignments",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset("assets/lottie/empty.json"),
            ),
            Text(
              AppLocalizations.of(context)!.youhaventtakenanyquizzesyet,
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
