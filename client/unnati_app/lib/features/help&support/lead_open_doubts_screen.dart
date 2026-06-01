import 'package:flutter/material.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';

class LeadOpenDoubtsScreen extends StatelessWidget {
  const LeadOpenDoubtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoubtListScreen(
      showOpenDoubts: true,
      title: 'Open Doubts',
    );
  }
}
