import 'package:flutter/material.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/features/live_doubt/lead_live_queue_tab.dart';
import 'package:unnati_app/features/connect/volunteer_doubts_view.dart';

class VolunteerConnectTab extends StatefulWidget {
  const VolunteerConnectTab({super.key});

  @override
  State<VolunteerConnectTab> createState() => _VolunteerConnectTabState();
}

class _VolunteerConnectTabState extends State<VolunteerConnectTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoading = true;
  bool _isLeadOrAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final role = await ApiService.getRole();
    final userData = await ApiService.getUserData();
    final effectiveRole = role ?? userData?['role']?.toString() ?? '';
    final lowerRole = effectiveRole.trim().toLowerCase();

    final isLead = lowerRole == 'admin' ||
        lowerRole.contains('lead') ||
        lowerRole.startsWith('js-') ||
        lowerRole.contains('secretary');

    if (!mounted) return;
    setState(() {
      _isLeadOrAdmin = isLead;
      if (isLead) {
        _tabController = TabController(length: 2, vsync: this);
      }
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 1. REGULAR VOLUNTEER VIEW:
    // Video Conference is removed completely; only Doubt Section is shown same as before.
    if (!_isLeadOrAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Connect',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const VolunteerDoubtsView(isLeadView: false),
      );
    }

    // 2. LEAD & ADMIN VIEW:
    // Connect has 2 sections: Video Conference (Live Queue) and Doubt Section.
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
          // Section 1: Video Conference (Live Doubt Queue for Leads/Admin)
          LeadLiveQueueTab(hideAppBar: true),
          // Section 2: Doubt Section (Open & Closed doubts)
          VolunteerDoubtsView(isLeadView: true),
        ],
      ),
    );
  }
}
