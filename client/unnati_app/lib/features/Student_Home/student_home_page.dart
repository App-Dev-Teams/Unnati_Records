import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/app_bar.dart';
import 'package:unnati_app/components/carousel_slider.dart';
import 'package:unnati_app/features/about_us/about.dart';
import 'package:unnati_app/features/developer/developers.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mainscreen.dart';
import 'package:unnati_app/l10n/app_localizations.dart';
//import 'package:unnati_app/components/pdf_components/pdf_navbar.dart';
import 'package:unnati_app/components/student_cards.dart';
import 'package:unnati_app/features/Student_quiz/student_quiz_screen.dart';
import 'package:unnati_app/services/api_service.dart';
import 'dart:async';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  Map<String, dynamic>? _user;
  StreamSubscription<Map<String, dynamic>?>? _userDataSubscription;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _userDataSubscription = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _loadUser() async {
    final user = await ApiService.getUserData();
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = (_user != null && _user!['name'] != null)
        ? (_user!['name'] as String)
        : 'Student';

    return Scaffold(
      appBar: MyAppBar(imageName: "NGO.png", name: name),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyCarouselSlider(), // carousel slider
            // mid part
            SizedBox(
              height: 200.h,
              width: 350.w,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PdfMainscreen()),
                  );
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
                      gradient: LinearGradient(
                        colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // left content
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // icon box
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF4DEEEA,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.library_books,
                                  color: Color(0xFF4DEEEA),
                                  size: 22,
                                ),
                              ),

                              // title
                              Text(
                                AppLocalizations.of(context)!.resources,
                                style: GoogleFonts.oswald(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              SizedBox(height: 6.h),

                              // subtitle
                              Text(
                                AppLocalizations.of(context)!.notespDFs,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // lottie
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
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // bottom part
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StudentCardsUtil(
                  // quiz
                  icon: Icons.fact_check_outlined,
                  iconColor: const Color(0xFF74ee15),
                  title: AppLocalizations.of(context)!.quiz,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.challengeyourknowledge,
                  nextPage: StudentQuizScreen(),
                ),
                StudentCardsUtil(
                  // about us
                  icon: Icons.info,
                  iconColor: Colors.white,
                  title: AppLocalizations.of(context)!.aboutus,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.ourstoryandvision,
                  nextPage: AboutPage(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StudentCardsUtil(
                  // developers
                  icon: Icons.computer,
                  iconColor: const Color.fromARGB(255, 244, 94, 255),
                  title: AppLocalizations.of(context)!.developers,
                  subtitle: AppLocalizations.of(context)!.meetourdevelopers,
                  nextPage: DevelopersPage(),
                ),
                SizedBox(width: 170.w),
              ],
            ),
            // SizedBox(height: 30.h,)
          ],
        ),
      ),
    );
  }
}
