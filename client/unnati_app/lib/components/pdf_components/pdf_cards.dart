import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PdfCards extends StatelessWidget {
  final String lottiePath;
  final String title;
  final double Height;
  final double width;
  final bool isLarge; 

  const PdfCards({
    super.key,
    required this.lottiePath,
    required this.title,
    required this.Height,
    required this.width,
    this.isLarge = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Height,
        width: width,
        child: Card(
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF111212),
                  Color(0xFF1E2A3A),
                  Color(0xFF2B3D54),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  height: isLarge ? 120.h : 65.h,
                  width: isLarge ? 120.h : 65.h,
                  child: Lottie.asset(
                    lottiePath,
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: isLarge ? 22.h : 16.h),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: isLarge ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: const Color.fromARGB(255, 204, 235, 255),
                    fontSize: isLarge ? 22.sp : 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
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

class PdfModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final double height;

  const PdfModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SizedBox(
        height: height.h,
        width: double.infinity,
        child: Card(
          elevation: 8,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF111212),
                  Color(0xFF1E2A3A),
                  Color(0xFF2B3D54),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
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
