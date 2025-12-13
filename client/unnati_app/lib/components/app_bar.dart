import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String name = "name";
  String imageName;
  MyAppBar({super.key, required this.imageName, required this.name});

  String greet() {
    DateTime now = DateTime.now(); //fetch current time and greet
    if (now.hour >= 5 && now.hour < 12) {
      return "Good Morning";
    } else if (now.hour >= 12 && now.hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(255, 9, 12, 19),
      elevation: 2,
      shadowColor: Colors.black,
      leading: Row(
        children: [
          SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/unnatiLogoColourFix.png"),//if not personal pic-> by default unnati logo
            foregroundImage: AssetImage("assets/images/$imageName"), // if profile pic change -> new profile pic
            radius: 20.r, //user image
          ),
        ],
      ),
      title: Column(//title
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hey, $name",
            style: GoogleFonts.oswald(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
          ), //user name
          Text(
            greet(),
            style: GoogleFonts.oswald(color: Colors.white, fontSize: 12), //greet
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            print("Navigate to Notification pannel");
          },
          icon: Icon(Icons.notifications_on,color: Colors.white,size: 22.r,),
        ),
        SizedBox(width: 10.w,)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
