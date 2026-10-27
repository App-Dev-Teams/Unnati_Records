import 'package:flutter/material.dart';
import 'package:unnati_app/features/live_doubt/student_live_doubt_tab.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connect',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color.fromARGB(255, 114, 155, 208),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(
              icon: Icon(Icons.video_camera_front_outlined),
              text: 'Video Conference',
            ),
            Tab(
              icon: Icon(Icons.forum_outlined),
              text: 'Doubts',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Section 1: Video Conference (Live 1-to-1 doubt request with mentors)
          StudentLiveDoubtTab(hideAppBar: true),
          // Section 2: Doubt Section (My doubts threads & ask doubt)
          DoubtListScreen(title: 'My Doubts', hideAppBar: true),
        ],
      ),
    );
  }
}
