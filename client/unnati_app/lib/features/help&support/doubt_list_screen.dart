import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/Providers/doubt_provider.dart';
import 'package:unnati_app/features/help&support/create_doubt_screen.dart';
import 'package:unnati_app/features/help&support/doubt_thread_screen.dart';
import 'package:unnati_app/models/doubt.dart';

class DoubtListScreen extends ConsumerStatefulWidget {
  final bool showOpenDoubts;
  final bool showClosedDoubts;
  final String title;

  const DoubtListScreen({
    super.key,
    this.showOpenDoubts = false,
    this.showClosedDoubts = false,
    this.title = 'My Doubts',
  });

  @override
  ConsumerState<DoubtListScreen> createState() => _DoubtListScreenState();
}

class _DoubtListScreenState extends ConsumerState<DoubtListScreen> {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      _refresh();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (widget.showOpenDoubts) {
      ref.invalidate(openDoubtsProvider);
      return;
    }
    if (widget.showClosedDoubts) {
      ref.invalidate(closedDoubtsProvider);
      return;
    }
    ref.invalidate(myDoubtsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final doubtsAsync = widget.showOpenDoubts
        ? ref.watch(openDoubtsProvider)
        : widget.showClosedDoubts
        ? ref.watch(closedDoubtsProvider)
        : ref.watch(myDoubtsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: (widget.showOpenDoubts || widget.showClosedDoubts)
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateDoubtScreen()),
                );
                if (created == true) {
                  _refresh();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Doubt'),
            ),
      body: doubtsAsync.when(
        data: (doubts) {
          if (doubts.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(
                    child: Text(
                      widget.showOpenDoubts
                          ? 'No open doubts right now.'
                          : 'No doubts yet. Create your first doubt.',
                      style: GoogleFonts.oswald(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final doubt = doubts[index];
                return _DoubtCard(
                  doubt: doubt,
                  showStudentName: widget.showOpenDoubts,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoubtThreadScreen(
                          doubtId: doubt.id,
                          isLeadView: widget.showOpenDoubts,
                        ),
                      ),
                    );
                    _refresh();
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: doubts.length,
            ),
          );
        },
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load doubts: $error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _DoubtCard extends StatelessWidget {
  final Doubt doubt;
  final bool showStudentName;
  final VoidCallback onTap;

  const _DoubtCard({
    required this.doubt,
    required this.showStudentName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = doubt.isOpen ? Colors.green : Colors.red;
    final createdAtText = doubt.createdAt == null
        ? 'No date'
        : '${doubt.createdAt!.day.toString().padLeft(2, '0')}/${doubt.createdAt!.month.toString().padLeft(2, '0')}/${doubt.createdAt!.year}';

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doubt.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      doubt.isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Subject: ${doubt.subject.isEmpty ? 'General' : doubt.subject}',
              ),
              if (showStudentName)
                Text('Student: ${doubt.studentName ?? 'Unknown'}'),
              const SizedBox(height: 6),
              Text('Created: $createdAtText'),
            ],
          ),
        ),
      ),
    );
  }
}
