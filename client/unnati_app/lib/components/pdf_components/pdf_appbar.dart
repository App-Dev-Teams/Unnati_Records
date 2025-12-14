import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfAppBar extends StatelessWidget implements PreferredSizeWidget {
  String name = "name";
  String imageName;
  PdfAppBar({super.key, required this.imageName, required this.name});

  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(255, 9, 12, 19),
      elevation: 2,
      shadowColor: Colors.black,
      leading: Row(
        children: [
          SizedBox(width: 12.w),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/unnatiLogoColourFix.png"),
            foregroundImage: AssetImage("assets/images/$imageName"), 
            radius: 14.r, //user image
          ),
          SizedBox(width: 10.w,),
        ],
      ),
      title: Column(//title
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Text(
            "$name",
            style: GoogleFonts.oswald(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
          ), 
          
        ],
      ),
      actions: [
        
        SizedBox(width: 10.w,)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}