import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VolunteerCardUtil extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color curvedColor;
  const VolunteerCardUtil({super.key,
  required this.title,
  required this.subtitle,
  required this.curvedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  width: 165.w,
  height: 135,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Stack(
    children: [
      // Top blue curved border
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 7.h,
          decoration:  BoxDecoration(
            color: curvedColor, // blue color
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(18),
            ),
          ),
        ),
      ),

      // Content
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              title,
              style: GoogleFonts.roboto(fontSize: 13,fontWeight: FontWeight.w600,color: const Color.fromARGB(255, 113, 113, 113),height: 1.2)
            ),
            const SizedBox(height: 10),
             Text(
              subtitle,
              style: GoogleFonts.oswald(fontSize: 34,fontWeight: FontWeight.w600,color: Colors.black)
            
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}