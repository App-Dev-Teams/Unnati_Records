import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String imageName;

  const PdfAppBar({
    super.key,
    required this.imageName,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      elevation: 2,
      shadowColor: Colors.black,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),


      title: Row(
       // mainAxisSize: MainAxisSize.,
       mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage:
                const AssetImage("assets/images/unnatiLogoColourFix.png"),
            foregroundImage: AssetImage("assets/images/$imageName"),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      centerTitle: true,

      actions: const [
        SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
