import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/volunteer_attendance_page.dart';
import 'package:unnati_app/features/volunteer_resources/volunteer_resources_page.dart';
import 'package:unnati_app/features/volunteer_quiz/quiz_view.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class VolunteerHomeCard extends StatelessWidget {
  const VolunteerHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
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
                    //title
                    SizedBox(
                      height: 40,
                      // width: 210,
                      child: Text(
                        AppLocalizations.of(context)!.eMPOWERINGdREAMS,
                        style: GoogleFonts.oswald(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    //subtitle
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.jointhejourneyofbridgingthedigitaldividethroughdigiXplorenetritvaakshar,
                      style: GoogleFonts.roboto(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    //options
                    Row(
                      children: [
                        InkWell(
                          //attendance
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VolunteerAttendancePage(),
                              ),
                            ); //for testing it is kept at profile page
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.attendance,
                                style: GoogleFonts.oswald(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          //resources
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VolunteerResourcesPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.resources,
                                style: GoogleFonts.oswald(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          //quizzes
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QuizViewPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF74ee15),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppLocalizations.of(context)!.quizzes,
                                    style: GoogleFonts.oswald(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
