import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/components/app_bar.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/programs_card_util.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_card_util.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_home_card.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_home_card_2.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: MyAppBar(imageName: "unnatiLogoColourFix.png", name: "Priyanshu"),
      
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
              child: Container(height: 25.h,width: 7.h,color: Colors.black,),
            ),
            SizedBox(width: 10.w,),
            Text("OUR PROGRAMS",style: GoogleFonts.oswald(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),)
          ],),
          ProgramsCardUtil(title: "DigiXplore",subtitle: "Interactive live classes bridging the digital gap",logo: "unnatiLogoColourFix.png",),
          ProgramsCardUtil(title: "Netritva",subtitle: "Holistic mentorship & doubt sessions for holistic growth",logo: "unnatiLogoColourFix.png",),
          ProgramsCardUtil(title: "Akshar",subtitle: "Nukkad classes",logo: "unnatiLogoColourFix.png",),
          SizedBox(height: 20.h,),


          //bottom part of body
          VolunteerHomeCard2(),
          SizedBox(height: 20.h,),

        ],
      ),
    ),
    );
    
    
    
  }
}
