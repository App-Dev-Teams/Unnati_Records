import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/Providers/language_provider.dart';
import 'package:unnati_app/components/toogleLanguage.dart';
import 'package:unnati_app/features/auth/view/login_page_student.dart';
import 'package:unnati_app/features/auth/view/login_page_volunteer.dart';
import 'package:unnati_app/features/auth/view/signup_as.dart';
import 'package:unnati_app/l10n/app_localizations.dart';

class LoginPage1 extends ConsumerStatefulWidget {
  const LoginPage1({super.key});

  @override
  ConsumerState<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends ConsumerState<LoginPage1> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      bottom: true,
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
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
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
                Lottie.asset(
                  'assets/lottie/two-people-thinking.json',
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
                          "${l10n.youAre}?",
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
                              builder: (context) => LoginPageVolunteer(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            l10n.volunteer,
                            style: GoogleFonts.cormorantSc(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h, width: double.infinity),
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
                              builder: (context) => LoginPageStudent(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            l10n.student,
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupAs()),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "${l10n.dontHaveAnAccount}?",
                        style: TextStyle(
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red,
                          color: Colors.red,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1), // Spacing between text and underline
                      Container(
                        width: 110.w, // Underline width
                        height: 1, // Underline thickness
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
