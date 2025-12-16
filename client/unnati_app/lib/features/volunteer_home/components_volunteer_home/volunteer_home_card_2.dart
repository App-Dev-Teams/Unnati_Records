import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class VolunteerHomeCard2 extends StatefulWidget {
  const VolunteerHomeCard2({super.key});

  @override
  State<VolunteerHomeCard2> createState() => _VolunteerHomeCard2State();
}

class _VolunteerHomeCard2State extends State<VolunteerHomeCard2> {
  int isYesSelected = 0; //variable to store yes/no
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
                    //Unnati logo
                    Container(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        'assets/images/unnatiLogoColourFix.png',
                      ),
                    ),

                    SizedBox(height: 12.h),

                    //title
                    Text(
                      'Are you proud member ?',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    //options
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isYesSelected = 1;
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                'YES',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                           setState(() {
                              isYesSelected = 2;
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                'NO',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 10,
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

              //lottie
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: isYesSelected == 1
                      ? Lottie.asset(
                          'assets/lottie/congo.json',
                          height: 120.h,
                          fit: BoxFit.contain,
                        )
                      : isYesSelected == 2
                      ? Lottie.asset(
                          'assets/lottie/sad_emotion.json',
                          height: 150.h,
                          fit: BoxFit.contain,
                        )
                      : Lottie.asset(
                          'assets/lottie/Question-boy.json',
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
