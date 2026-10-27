import 'package:flutter/material.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/l10n/app_localizations.dart';

class VolunteerDoubtsView extends StatefulWidget {
  final bool isLeadView;
  const VolunteerDoubtsView({super.key, this.isLeadView = false});

  @override
  State<VolunteerDoubtsView> createState() => _VolunteerDoubtsViewState();
}

class _VolunteerDoubtsViewState extends State<VolunteerDoubtsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _canManageDoubts = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final user = await ApiService.getUserData();
    final permissions = ApiService.permissionsFromUserData(user);
    final canManage = permissions.contains('REPLY_DOUBTS') ||
        permissions.contains('RESOLVE_DOUBTS');

    if (!mounted) return;
    setState(() {
      _canManageDoubts = canManage;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color.fromARGB(255, 114, 155, 208),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mark_chat_unread_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(l10n.openDoubts),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.task_alt, size: 18),
                    const SizedBox(width: 6),
                    Text(l10n.closedDoubts),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              DoubtListScreen(
                showOpenDoubts: true,
                hideAppBar: true,
                readOnly: !_canManageDoubts,
                title: l10n.openDoubts,
              ),
              DoubtListScreen(
                showClosedDoubts: true,
                hideAppBar: true,
                readOnly: !_canManageDoubts,
                title: l10n.closedDoubts,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
