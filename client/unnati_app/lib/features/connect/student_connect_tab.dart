import 'package:flutter/material.dart';
import 'package:unnati_app/features/live_doubt/student_live_doubt_tab.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';
import 'package:unnati_app/l10n/app_localizations.dart';

class StudentConnectTab extends StatefulWidget {
  const StudentConnectTab({super.key});

  @override
  State<StudentConnectTab> createState() => _StudentConnectTabState();
}

class _StudentConnectTabState extends State<StudentConnectTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.connect,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color.fromARGB(255, 114, 155, 208),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            Tab(
              icon: const Icon(Icons.video_camera_front_outlined),
              text: l10n.videoConference,
            ),
            Tab(
              icon: const Icon(Icons.forum_outlined),
              text: l10n.doubts,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Section 1: Video Conference (Live 1-to-1 doubt request with mentors)
          const StudentLiveDoubtTab(hideAppBar: true),
          // Section 2: Doubt Section (My doubts threads & ask doubt)
          DoubtListScreen(title: l10n.myDoubts, hideAppBar: true),
        ],
      ),
    );
  }
}
