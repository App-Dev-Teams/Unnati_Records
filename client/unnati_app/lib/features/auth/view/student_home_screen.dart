import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/components/app_bar.dart';
import 'package:unnati_app/components/bottom_nav_bar.dart';
import 'package:unnati_app/features/auth/view/student_quiz_screen.dart';
import 'package:unnati_app/features/auth/view/studednt_profile_screen.dart';
import 'package:unnati_app/features/auth/view/student_home_page.dart';
import 'package:unnati_app/providers.dart/bottom_nav_provider.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentIndex=ref.watch(bottomNavIndexProvider);

    final pages =[
      const StudentQuizScreen(),  //0 index
      const StudentHomePage(),  //1 index
      const StudedntProfileScreen(),  //2 index
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(imageName: "unnatiLogoColourFix.png", name: "Priyanshu"),
      body: pages[currentIndex],
      bottomNavigationBar: MyBottomNavBar(),
    );
    
  }
}
