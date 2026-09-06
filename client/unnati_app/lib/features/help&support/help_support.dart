import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';
import 'package:unnati_app/features/help&support/lead_open_doubts_screen.dart';
import 'package:unnati_app/features/help&support/lead_closed_doubts_screen.dart';
import 'package:unnati_app/services/api_service.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  bool _isStudent = false;
  List<String> _permissions = [];
  StreamSubscription<Map<String, dynamic>?>? _userSub;

  @override
  void initState() {
    super.initState();
    _loadAuthContext();
    // Subscribe to user changes so UI updates when permissions or profile data change.
    _userSub = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      setState(() {
        _permissions = ApiService.permissionsFromUserData(user);
        _isStudent = ApiService.isStudentUserData(user);
      });
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> _loadAuthContext() async {
    final user = await ApiService.getUserData();
    if (!mounted) return;
    setState(() {
      _permissions = ApiService.permissionsFromUserData(user);
      _isStudent = ApiService.isStudentUserData(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final canManageDoubts =
        _permissions.contains('REPLY_DOUBTS') ||
        _permissions.contains('RESOLVE_DOUBTS');

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Doubt Support',
            style: GoogleFonts.oswald(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Ask, track, and resolve learning doubts from one place.'),
          const SizedBox(height: 18),
          if (_isStudent)
            _SupportCard(
              title: 'My Doubts',
              subtitle: 'Create and track your doubt threads.',
              icon: Icons.question_answer_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DoubtListScreen(title: 'My Doubts'),
                  ),
                );
              },
            ),
          if (canManageDoubts)
            _SupportCard(
              title: 'Open Doubts',
              subtitle: 'Respond to student doubts and resolve them.',
              icon: Icons.support_agent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeadOpenDoubtsScreen(),
                  ),
                );
              },
            ),
          if (canManageDoubts)
            _SupportCard(
              title: 'Closed Doubts',
              subtitle: 'View resolved doubt threads.',
              icon: Icons.archive,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeadClosedDoubtsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SupportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(
          title,
          style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
