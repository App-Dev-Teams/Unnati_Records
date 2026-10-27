import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/bottom_nav_provider.dart';
import 'package:unnati_app/components/bottom_nav_bar.dart';
import 'package:unnati_app/features/volunteer_profile/volunteer_profile_page.dart';
import 'package:unnati_app/features/volunteer_home/volunteer_home_page.dart';
import 'package:unnati_app/features/volunteer_resources/volunteer_resources_page.dart';
import 'package:unnati_app/features/connect/volunteer_connect_tab.dart';

class VolunteerHomeScreen extends ConsumerStatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  ConsumerState<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends ConsumerState<VolunteerHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Always start on Home tab (index 0) when opening VolunteerHomeScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(bottomNavIndexProvider.notifier).state = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final pages = [
      const VolunteerHomePage(),          // 0: Home
      const VolunteerConnectTab(),        // 1: Connect (Video Conference for leads + Doubts for all)
      const VolunteerResourcesPage(),     // 2: Resources
      const VolunteerProfilePage(),       // 3: Profile
    ];

    final safeIndex = currentIndex < pages.length ? currentIndex : 0;

    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: const BottomNavBar(
          navIcon1: Icons.home_outlined,
          navIcon2: Icons.phone_in_talk_outlined,
          navIcon3: Icons.add_to_photos_outlined,
          navIcon4: Icons.person_outline,
          labelName1: "Home",
          labelName2: "Connect",
          labelName3: "Resources",
          labelName4: "Profile",
          navColor: Color.fromARGB(255, 211, 211, 211),
        ),
      ),
    );
  }
}
