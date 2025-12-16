import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgramsCardUtil extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logo;
  const ProgramsCardUtil({super.key, required this.title,required this.subtitle,required this.logo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){}, //future navigation //take navigating path from user
      child: SizedBox(
        width: 350.w,
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.grey.shade100,
                  ),
                  padding: EdgeInsets.all(6.r),
                  child: Image.asset(
                    'assets/images/$logo', //respective program logo (send logo name with image type)
                    fit: BoxFit.contain,
                  ),
                ),
      
                SizedBox(width: 12.w),
      
                //text content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(
                        title,
                        maxLines: 1,
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
      
                      SizedBox(height: 4.h),
      
                      //subtitle
                      Text(
                        subtitle,
                        maxLines: 2,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
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
