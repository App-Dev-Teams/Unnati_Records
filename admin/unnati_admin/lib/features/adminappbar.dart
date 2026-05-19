import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/services/api_service.dart';
import 'package:unnati_admin/services/auth_gate.dart';
import 'package:unnati_admin/features/admin_profile.dart';

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

    final double nameFontSize = isDesktop ? 20 : 18;
    final double roleFontSize = isDesktop ? 13 : 11;
    final double avatarRadius = isDesktop ? 22 : 18;

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      elevation: 4,
      shadowColor: Colors.black54,
      toolbarHeight: 70,
      titleSpacing: 20,

      title: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: const Color.fromARGB(255, 9, 75, 128),
              backgroundImage: AssetImage("assets/images/$imageName"),
            ),

            SizedBox(width: 16.w),

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
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Administrator",
                    style: GoogleFonts.nunito(
                      color: Colors.lightBlueAccent,
                      fontSize: roleFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
       

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            iconSize: 28,
            color: const Color.fromARGB(255, 14, 22, 33),
            elevation: 8,
            onSelected: (value) async {
              if (value == "Profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminProfilePage()),
                );
              } else if (value == "Logout") {
                await AdminApiService.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                    (route) => false,
                  );
                }
              }
            },
            itemBuilder: (context) => [
              _menuItem("Profile", Icons.person_outline),
              _menuItem("Settings", Icons.settings_outlined),
              const PopupMenuDivider(),
              _menuItem("Logout", Icons.logout),
            ],
          ),
        ),

        SizedBox(width: 8.w),
      ],
    );
  }

  PopupMenuItem<String> _menuItem(String text, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      height: 48,
      child: Row(
        children: [
          Icon(icon, color: Colors.lightBlueAccent, size: 20),
          SizedBox(width: 14.w),
          Text(
            text,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
