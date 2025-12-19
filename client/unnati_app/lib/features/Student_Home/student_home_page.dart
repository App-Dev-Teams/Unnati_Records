import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/carousel_slider.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mainscreen.dart';
//import 'package:unnati_app/components/pdf_components/pdf_navbar.dart';
import 'package:unnati_app/components/student_cards.dart';
import 'package:unnati_app/features/Student_profile/studednt_profile_screen.dart';
import 'package:unnati_app/features/Student_quiz/student_quiz_screen.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyCarouselSlider(), //carousel slider
            //mid part
            SizedBox(
              height: 200.h,
              width: 350.w,
              child: 
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfMainscreen()));
                },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //left content
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //icon box
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4DEEEA).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(
                              Icons.library_books,
                              color: Color(0xFF4DEEEA),
                              size: 22,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          //title
                          Text(
                            'Resources',
                            style: GoogleFonts.oswald(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 6.h),

                          //subtitle
                          Text(
                            'Notes •  PDFs',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //lottie
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Lottie.asset(
                          'assets/lottie/Books.json',
                          height: 150.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),)
            ),
          ),

          //bottom part
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StudentCardsUtil(
                //settings
                icon: Icons.settings,
                iconColor: Color(0xFF74ee15),
                title: "Settings",
                subtitle: "Control your app settings",
                nextPage:
                    StudentQuizScreen(), ////// replace the student Quiz page with the correct page whenever required
                ///for testing purpose it is set to studentProfile Screen
              ),
              StudentCardsUtil(
                //help and support
                icon: Icons.support_agent,
                iconColor: Color.fromARGB(255, 255, 120, 47),
                title: "Help & Support",
                subtitle: "Assistance at your fingertips",
                nextPage: StudedntProfileScreen(),

                /// fortesting it is bydefault studntProfileScreen -- change to reqired page
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StudentCardsUtil(
                //settings
                icon: Icons.computer,
                iconColor: Color.fromARGB(255, 244, 94, 255),
                title: "Developers",
                subtitle: "Meet our developers",
                nextPage: StudedntProfileScreen(),

                /// fortesting it is bydefault studntProfileScreen -- change to reqired page
              ),
              StudentCardsUtil(
                //about us
                icon: Icons.info,
                iconColor: Colors.white,
                title: "About Us",
                subtitle: "Our story and vision",
                nextPage: StudedntProfileScreen(),

                /// fortesting it is bydefault studntProfileScreen -- change to reqired page
              ),
            ],
          ),
          // SizedBox(height: 30.h,)
        ],
      ),
    );
  }
}
