import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/components/pdf_components/pdf_cards.dart';
import 'package:unnati_app/features/pdf_feature/pdf_digiexplore.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mydownloads.dart';
import 'package:unnati_app/features/pdf_feature/pdf_quizzes.dart';
class PdfMainscreen extends StatefulWidget{
  @override
  _PdfMainscreenState createState() => _PdfMainscreenState();
}
class _PdfMainscreenState extends State<PdfMainscreen>{
  @override
  Widget build(BuildContext context){
    return 
      Center(
      child: Column(
        

        children: [
            SizedBox(height: 40,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfDxscreen()));
              },
            child: PdfCards(icon:Icons.library_books , iconColor:Colors.lightBlueAccent , title: "DigiExplore Syllabus",Height: 175.h, width: 175.w),),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfQuizzes()));
              },
            child: PdfCards(icon:Icons.picture_as_pdf , iconColor:Colors.redAccent , title: "Previous Quizzes",Height: 175.h, width: 175.w),),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfMydownloads()));
              },
            child: PdfCards(icon:Icons.note , iconColor:Colors.greenAccent , title: "My downloads", Height: 175.h, width: 175 .w),)
        ],
      ),);
      
  }
}