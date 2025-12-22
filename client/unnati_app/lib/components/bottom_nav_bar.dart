import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/bottom_nav_provider.dart';

class BottomNavBar extends ConsumerWidget {
  final IconData navIcon1;
  final IconData navIcon2;
  final IconData navIcon3;

  final String labelName1;
  final String labelName2;
  final String labelName3;

  final Color navColor;
  final Color navBackgroundColor;
  final Color navButtonColor;

  const BottomNavBar({
    super.key,
    required this.navIcon1,
    required this.navIcon2,
    required this.navIcon3,
    required this.labelName1,
    required this.labelName2,
    required this.labelName3,
    this.navColor  = Colors.white,
    this.navBackgroundColor =Colors.transparent,
    this.navButtonColor = const Color.fromARGB(255, 114, 155, 208),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider); //change listener

    return CurvedNavigationBar(
      color: navColor,
      index: currentIndex,
      items: [
        CurvedNavigationBarItem(child: Icon(navIcon1), label: labelName1),
        CurvedNavigationBarItem(child: Icon(navIcon2), label: labelName2),
        CurvedNavigationBarItem(child: Icon(navIcon3), label: labelName3),
      ],
      backgroundColor: navBackgroundColor,
      buttonBackgroundColor: navButtonColor,
      
      onTap: (index) {
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
    );
  }
}
