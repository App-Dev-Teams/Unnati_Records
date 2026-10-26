import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';
import 'package:unnati_app/services/api_service.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

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
    final canViewDoubts =
        canManageDoubts || _permissions.contains('VIEW_DOUBTS');

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.helpsupport)),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            AppLocalizations.of(context)!.doubtsupport,
            style: GoogleFonts.oswald(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            AppLocalizations.of(
              context,
            )!.asktrackandresolvelearningdoubtsfromoneplace,
          ),
          SizedBox(height: 18),
          if (_isStudent)
            _SupportCard(
              title: AppLocalizations.of(context)!.mydoubts,
              subtitle: AppLocalizations.of(
                context,
              )!.createandtrackyourdoubtthreads,
              icon: Icons.question_answer_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoubtListScreen(
                      title: AppLocalizations.of(context)!.mydoubts,
                    ),
                  ),
                );
              },
            ),
          if (canViewDoubts)
            _SupportCard(
              title: AppLocalizations.of(context)!.opendoubts,
              subtitle: canManageDoubts
                  ? 'Respond to student doubts and resolve them.'
                  : 'View student doubts.',
              icon: Icons.support_agent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoubtListScreen(
                      showOpenDoubts: true,
                      title: AppLocalizations.of(context)!.opendoubts,
                      readOnly: !canManageDoubts,
                    ),
                  ),
                );
              },
            ),
          if (canViewDoubts)
            _SupportCard(
              title: AppLocalizations.of(context)!.closeddoubts,
              subtitle: AppLocalizations.of(context)!.viewresolveddoubtthreads,
              icon: Icons.archive,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoubtListScreen(
                      showClosedDoubts: true,
                      title: AppLocalizations.of(context)!.closeddoubts,
                      readOnly: !canManageDoubts,
                    ),
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
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(
          title,
          style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
