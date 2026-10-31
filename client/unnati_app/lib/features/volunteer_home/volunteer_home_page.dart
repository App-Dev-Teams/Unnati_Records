import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/components/app_bar.dart';
import 'package:unnati_app/features/help&support/help_support.dart';
import 'package:unnati_app/features/our_programs/akshar.dart';
import 'package:unnati_app/features/our_programs/digixplore.dart';
import 'package:unnati_app/features/our_programs/netritva.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/programs_card_util.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_card_util.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_home_card.dart';
import 'package:unnati_app/features/volunteer_quiz/quiz_view.dart';
import 'package:unnati_app/services/api_service.dart';


import 'package:unnati_app/l10n/app_localizations.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: ApiService.getUserData(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var user = asyncSnapshot.data;
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 221, 221, 221),

            appBar: MyAppBar(
              imageName: "unnatiLogoColourFix.png",
              name: user!["name"],
            ),

            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //top part of body
                  SizedBox(height: 5.h),
                  VolunteerHomeCard(), //volunteer card
                  SizedBox(height: 17.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      VolunteerCardUtil(
                        title: AppLocalizations.of(context)!.studentsnmentored,
                        subtitle: AppLocalizations.of(context)!.text1200,
                        curvedColor: Colors.blue,
                      ),
                      VolunteerCardUtil(
                        title: AppLocalizations.of(context)!.classestaken,
                        subtitle: AppLocalizations.of(context)!.text500,
                        curvedColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  //middle part of body
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          height: 25.h,
                          width: 7.h,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        AppLocalizations.of(context)!.oURpROGRAMS,
                        style: GoogleFonts.oswald(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ProgramsCardUtil(
                    title: l10n.digixploreDigiXplore,
                    subtitle:
                        l10n.interactiveliveclassesbridgingthedigitalgap,
                    logo: "digilogo.png",
                    path: DigixplorePage(),
                  ),
                  ProgramsCardUtil(
                    title: l10n.netritva,
                    subtitle:
                        l10n.holisticmentorshipdoubtsessionsforholisticgrowth,
                    logo: "netrilogo.png",
                    path: NetritvaPage(),
                  ),
                  ProgramsCardUtil(
                    title: l10n.akshar,
                    subtitle: l10n.nukkadclasses,
                    logo: "aklogo.png",
                    path: AksharPage(),
                  ),
                  SizedBox(height: 20.h),

                  //bottom part of body
                  // VolunteerHomeCard2(),
                  SizedBox(height: 10.h),

                  

                  // Quizzes card
                  Card(
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpSupport(),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(
                              Icons.support_agent,
                              color: Colors.orange,
                              size: 15,
                            ),
                          ),
                          title: Text(
                            l10n.helpAndSupport,
                            style: GoogleFonts.oswald(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            l10n.openAndResolveStudentDoubts,
                            style: GoogleFonts.oswald(color: Colors.grey),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Quizzes card
                  Card(
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuizViewPage(),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF74ee15).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(
                              Icons.fact_check_outlined,
                              color: Color(0xFF74ee15),
                              size: 18,
                            ),
                          ),
                          title: Text(
                            l10n.quizManagement,
                            style: GoogleFonts.oswald(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            l10n.viewAndUploadStudentAssessments,
                            style: GoogleFonts.oswald(color: Colors.grey),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Quizzes card

                  SizedBox(height: 10.h),

                  // Card(
                  //   elevation: 8,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(16.r),
                  //   ),
                  //   child: Container(
                  //     padding: EdgeInsets.all(16.r),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16.r),
                  //       gradient: LinearGradient(
                  //         colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //       ),
                  //     ),
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (_) => DevelopersPage()),
                  //         );
                  //       },
                  //       child: ListTile(
                  //         leading: Container(
                  //           padding: EdgeInsets.all(8.r),
                  //           decoration: BoxDecoration(
                  //             color: Colors.lightBlueAccent.withValues(
                  //               alpha: 0.10,
                  //             ),
                  //             borderRadius: BorderRadius.circular(8.r),
                  //           ),
                  //           child: Icon(
                  //             Icons.computer,
                  //             color: Colors.lightBlueAccent,
                  //             size: 15,
                  //           ),
                  //         ),
                  //         title: Text(
                  //           AppLocalizations.of(context)!.developers,
                  //           style: GoogleFonts.oswald(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //         subtitle: Text(
                  //           AppLocalizations.of(context)!.meetourdevelopers,
                  //           style: GoogleFonts.oswald(color: Colors.grey),
                  //         ),
                  //         trailing: Icon(
                  //           Icons.arrow_forward_ios,
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 21),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
