import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/providers.dart/bottom_nav_provider.dart';

class MyBottomNavBar extends ConsumerWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return CurvedNavigationBar(
      index: currentIndex,
      items: [
        CurvedNavigationBarItem(child: Icon(Icons.fact_check_outlined),
        label: 'Quiz',
        ),
        CurvedNavigationBarItem(child: Icon(Icons.home_outlined),
        label: 'home',
        ),
        CurvedNavigationBarItem(child: Icon(Icons.person_outline),
        label: 'profile',
        ),
        ],
        backgroundColor: Color.fromARGB(255, 9, 12, 19),
        onTap: (index){
         ref.read(bottomNavIndexProvider.notifier).state=index;
        },
        );
  }
}