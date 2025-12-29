import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/bottom_nav_provider.dart';
import 'package:unnati_app/components/app_bar.dart';
import 'package:unnati_app/components/bottom_nav_bar.dart';
import 'package:unnati_app/features/volunteer_profile/volunteer_profile_page.dart';
import 'package:unnati_app/features/volunteer_home/volunteer_home_page.dart';
import 'package:unnati_app/features/volunteer_resources/volunteer_resources_page.dart';
//import 'package:unnati_app/providers.dart/bottom_nav_provider.dart';

class VolunteerHomeScreen extends ConsumerWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final pages = [
      const VolunteerResourcesPage(), //0 index
      const VolunteerHomePage(), //1 index
      const VolunteerProfilePage(), //2 index
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        navIcon1: Icons.add_to_photos_outlined,
        navIcon2: Icons.home_outlined,
        navIcon3: Icons.person_outline,
        labelName1: "Extra", //for testing it is directed to resources page in future it can be replaced by any additional feature
        labelName2: "Home",
        labelName3: "Profile",
        navColor: const Color.fromARGB(255, 211, 211, 211),
      ),
    );
  }
}
