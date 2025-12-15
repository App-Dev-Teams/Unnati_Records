import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/components/pdf_components/pdf_cards.dart';
import 'package:unnati_app/features/pdf_feature/comments.dart';
import 'package:unnati_app/features/pdf_feature/pdf_assignments.dart';
import 'package:unnati_app/features/pdf_feature/pdf_digiexplore.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mydownloads.dart';
import 'package:unnati_app/features/pdf_feature/pdf_quizzes.dart';

class PdfMainscreen extends StatefulWidget {
  @override
  _PdfMainscreenState createState() => _PdfMainscreenState();
}

class _PdfMainscreenState extends State<PdfMainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdfAppBar(imageName: "unnatiLogoColourFix.png", name: "Utkarsh's Resources"), // to be replaced by backend username 
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Center(
          child: Column(
            
            children: [

              SizedBox(height: 30.h),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PdfDxscreen()),
                  );
                },
              child:  PdfCards(lottiePath: "assets/lottie/Exams.json", title: "DigiExplore Syllabus", Height: 220.h, width: 350.h, isLarge: true,),),
              SizedBox(height: 20.h),
             
              Row(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PdfAssignments()),
                  );
                },
                child: PdfCards(
                  lottiePath: "assets/lottie/assignment.json", 
                  title: "Assignments Booklets",
                  Height: 175.h,
                  width: 175.w,
                ),
              ),

             // SizedBox(height: .h),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PdfQuizzes()),
                  );
                },
                child: PdfCards(
                  lottiePath: "assets/lottie/Quiz.json", 
                  title: "Previous Quiz Pdfs",
                  Height: 175.h,
                  width: 175.w,
                ),
              ),]),

              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [ InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PdfMydownloads()),
                  );
                },
                child: PdfCards(
                lottiePath: "assets/lottie/download.json", 
                  title: "My Downloads",
                  Height: 175.h,
                  width: 175.w,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CommentsPage()),
                  );
                },
                child: PdfCards(
                   lottiePath: "assets/lottie/comment.json", 
                  title: "Comment Your Doubts!",
                  Height: 175.h,
                  width: 175.w,
                ),
              ),],
              ),
          ]),
        ),
      ),
    );
  }
}
