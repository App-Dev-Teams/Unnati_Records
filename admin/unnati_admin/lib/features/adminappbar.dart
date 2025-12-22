import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String imageName;

  const AdminAppBar({
    super.key,
    required this.name,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isDesktop = width >= 900;

    final double nameFontSize = isDesktop ? 18 : 16;
    final double roleFontSize = isDesktop ? 12 : 10;
    final double avatarRadius = isDesktop ? 20 : 16;

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      elevation: 3,
      shadowColor: Colors.black,

      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),

      title: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: AssetImage("assets/images/$imageName"),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Administrator",
                  style: GoogleFonts.nunito(
                    color: Colors.lightBlueAccent,
                    fontSize: roleFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),

        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          color: const Color.fromARGB(255, 14, 22, 33),
          itemBuilder: (context) => [
            _menuItem("Profile", Icons.person_outline),
            _menuItem("Settings", Icons.settings_outlined),
            _menuItem("Logout", Icons.logout),
          ],
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  PopupMenuItem<String> _menuItem(String text, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Text(text, style: GoogleFonts.nunito(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
