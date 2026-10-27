import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/bottom_nav_provider.dart';
import 'package:unnati_app/components/bottom_nav_bar.dart';
import 'package:unnati_app/features/Student_quiz/student_quiz_screen.dart';
import 'package:unnati_app/features/Student_profile/student_profile_screen.dart';
import 'package:unnati_app/features/Student_Home/student_home_page.dart';
import 'package:unnati_app/features/connect/student_connect_tab.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Always start on Home tab (index 0) when opening StudentHomeScreen
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
      const StudentHomePage(),          // 0: Home
      const StudentConnectTab(),        // 1: Connect (Video Conference + Doubts)
      const StudentQuizScreen(),        // 2: Quiz
      const StudedntProfileScreen(),    // 3: Profile
    ];

    final safeIndex = currentIndex < pages.length ? currentIndex : 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[safeIndex],
        bottomNavigationBar: const BottomNavBar(
          navIcon1: Icons.home_outlined,
          navIcon2: Icons.phone_in_talk_outlined,
          navIcon3: Icons.fact_check_outlined,
          navIcon4: Icons.person_outline,
          labelName1: "Home",
          labelName2: "Connect",
          labelName3: "Quiz",
          labelName4: "Profile",
        ),
      ),
    );
  }
}
