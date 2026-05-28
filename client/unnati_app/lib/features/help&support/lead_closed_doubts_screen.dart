import 'package:flutter/material.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';

class LeadClosedDoubtsScreen extends StatelessWidget {
  const LeadClosedDoubtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoubtListScreen(
      showClosedDoubts: true,
      title: 'Closed Doubts',
    );
  }
}
