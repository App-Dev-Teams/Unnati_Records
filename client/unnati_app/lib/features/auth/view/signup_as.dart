import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/Providers/language_provider.dart';
import 'package:unnati_app/components/toogleLanguage.dart';
import 'package:unnati_app/features/auth/view/signup_student.dart';
import 'package:unnati_app/features/auth/view/signup_volunteer.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class SignupAs extends ConsumerStatefulWidget {
  const SignupAs({super.key});

  @override
  ConsumerState<SignupAs> createState() => _SignupAsState();
}

class _SignupAsState extends ConsumerState<SignupAs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
                appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            SizedBox(
              height: 40,
              // width: 40,
              child: LanguageToggle(
                currentLocale: Localizations.localeOf(context),
                onLanguageChanged: (locale) {
                  ref.watch(languageProvider.notifier).toggleLanguage();
                },
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ), //Scaffold backgroud color
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                //unnati logo
               Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/collegeLogo.png',
                        height: 55.h,
                        width: 55.w,
                      ),
          
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Container(
                          height: 50,
                          width: 2,
                          color: Color.fromARGB(184, 78, 78, 78),
                        ),
                      ),
                      Image.asset(
                        'assets/images/unnatiLogoColourFix.png',
                        height: 60.h,
                        width: 60.w,
                      ),
                    ],
                  ),
                SizedBox(height: 30.h, width: double.infinity),
                //lottie
                Lottie.asset(
                  'assets/lottie/student.json',
                  height: 150.h,
                  width: 150.w,
                ),
                SizedBox(height: 40.h, width: double.infinity),
          
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.signupas,
                          style: GoogleFonts.oswald(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h, width: double.infinity),
          
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          fixedSize: Size(150.w, 40.h),
                          backgroundColor: Color.fromARGB(255, 9, 75, 128),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpVolunteer(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.volunteer,
                            style: GoogleFonts.cormorantSc(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h, width: double.infinity),
                      //student
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          fixedSize: Size(150.w, 40.h),
                          backgroundColor: Color.fromARGB(255, 9, 75, 128),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupStudent(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.student,
                            style: GoogleFonts.cormorantSc(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
