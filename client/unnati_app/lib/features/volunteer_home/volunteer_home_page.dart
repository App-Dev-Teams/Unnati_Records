import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/components/app_bar.dart';
import 'package:unnati_app/features/developer/developers.dart';
import 'package:unnati_app/features/our_programs/akshar.dart';
import 'package:unnati_app/features/our_programs/digixplore.dart';
import 'package:unnati_app/features/our_programs/netriva.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/programs_card_util.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_card_util.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_home_card.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_home_card_2.dart';
import 'package:unnati_app/services/api_service.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getUserData(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var user = asyncSnapshot.data;
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 221, 221, 221),

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
                        title: "Students\nmentored",
                        subtitle: "1200+",
                        curvedColor: Colors.blue,
                      ),
                      VolunteerCardUtil(
                        title: "Classes taken",
                        subtitle: "500+",
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
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 25.h,
                          width: 7.h,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "OUR PROGRAMS",
                        style: GoogleFonts.oswald(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ProgramsCardUtil(
                    title: "DigiXplore",
                    subtitle:
                        "Interactive live classes bridging the digital gap",
                    logo: "unnatiLogoColourFix.png",
                    path: DigixplorePage(),
                  ),
                  ProgramsCardUtil(
                    title: "Netritva",
                    subtitle:
                        "Holistic mentorship & doubt sessions for holistic growth",
                    logo: "unnatiLogoColourFix.png",
                    path: NetrivaPage(),
                  ),
                  ProgramsCardUtil(
                    title: "Akshar",
                    subtitle: "Nukkad classes",
                    logo: "unnatiLogoColourFix.png",
                    path: AksharPage(),
                  ),
                  SizedBox(height: 20.h),

                  //bottom part of body
                  VolunteerHomeCard2(),
                  SizedBox(height: 10.h),

                  //developers
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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>DevelopersPage()));
                        },
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.computer,
                              color: Colors.lightBlueAccent,
                              size: 15,
                            ),
                          ),
                          title: Text(
                            "Developers",
                            style: GoogleFonts.oswald(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "Meet our developers",
                            style: GoogleFonts.oswald(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
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
