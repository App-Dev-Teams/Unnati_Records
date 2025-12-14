import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/pdf_navbarprovider.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mainscreen.dart';

class PdfNavScaffold extends ConsumerWidget {
  const PdfNavScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(pdfNavIndexProvider);

    return Scaffold(
      appBar: PdfAppBar(
        imageName: "unnatiLogoColourFix.png",
        name: "Utkarsh's Resources",
      ),
      body: IndexedStack(
        index: currentIndex,
        children:  [
          PdfMainscreen(),
          StudenttHomePage(),
          StudentProfileScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.fact_check_outlined),
            label: 'Resources',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          ref.read(pdfNavIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
class StudenttHomePage extends StatelessWidget { //DUMMY TO BE REPLACED BY OG
  const StudenttHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Student Home Page'),
    );
  }
}
class StudentProfileScreen extends StatelessWidget {//DUMMY TO BE REPLACED BY OG
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Student Profile Screen'),
    );
  }
}