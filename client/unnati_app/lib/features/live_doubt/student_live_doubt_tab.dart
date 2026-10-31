import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/features/live_doubt/live_video_conference_screen.dart';
import 'package:unnati_app/l10n/app_localizations.dart';

class StudentLiveDoubtTab extends StatefulWidget {
  final bool hideAppBar;
  const StudentLiveDoubtTab({super.key, this.hideAppBar = false});

  @override
  State<StudentLiveDoubtTab> createState() => _StudentLiveDoubtTabState();
}

class _StudentLiveDoubtTabState extends State<StudentLiveDoubtTab> {
  final _topicController = TextEditingController();
  final _customSubjectController = TextEditingController();
  String _selectedSubject = 'Mathematics';
  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'Social Science',
    'Computer / DigiXplore',
    'Others',
  ];

  bool _isLoading = false;
  Map<String, dynamic>? _activeSession;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _checkActiveSession();
    // Poll every 5 seconds to detect when a Lead schedules or begins the call
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) _checkActiveSession(silent: true);
    });
  }

  Future<void> _checkActiveSession({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    final status = await ApiService.checkMyLiveStatus();
    if (!mounted) return;

    if (status['active'] == true) {
      final sessionData = status['session'] as Map<String, dynamic>? ?? {};
      final startStr = sessionData['scheduledStartTime']?.toString();
      bool isExpired = false;
      if (startStr != null && (status['status'] == 'scheduled' || sessionData['status'] == 'scheduled')) {
        try {
          final start = DateTime.parse(startStr).toLocal();
          if (DateTime.now().difference(start).inMinutes >= 60) {
            isExpired = true;
          }
        } catch (_) {}
      }

      if (isExpired) {
        setState(() {
          _activeSession = null;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _activeSession = {
          ...sessionData,
          'canJoin': status['canJoin'] ?? false,
          'connection': status['connection'],
          'status': status['status'],
        };
        _isLoading = false;
      });
    } else {
      setState(() {
        _activeSession = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRequest() async {
    final effectiveSubject = _selectedSubject == 'Others'
        ? _customSubjectController.text.trim()
        : _selectedSubject;

    final l10n = AppLocalizations.of(context)!;

    if (effectiveSubject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.specifySubjectValidation)),
      );
      return;
    }

    final topic = _topicController.text.trim();
    if (topic.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.describeDoubtValidation)),
      );
      return;
    }

    setState(() => _isLoading = true);
    final res = await ApiService.requestLiveCall(
      subject: effectiveSubject,
      topic: topic,
    );
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      _topicController.clear();
      _customSubjectController.clear();
      _checkActiveSession();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.doubtRequestSubmittedSuccess)),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error'] ?? 'Could not submit doubt request.')),
      );
    }
  }

  Future<void> _cancelRequest() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: const Text('Are you sure you want to cancel this doubt conference?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    final res = await ApiService.cancelLiveRequest();
    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? 'Session cancelled.')),
    );
    _checkActiveSession();
  }

  Future<void> _joinConference() async {
    if (_activeSession == null) return;
    final sessionId = _activeSession!['_id'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final res = await ApiService.startLiveCall(sessionId);
    if (!mounted) return;
    Navigator.pop(context); // Close loader

    if (res['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LiveVideoConferenceScreen(
            sessionId: sessionId,
            appId: res['appId'] is int ? res['appId'] : int.parse(res['appId'].toString()),
            appSign: res['appSign']?.toString() ?? '',
            channelName: res['channelName'] ?? '',
            userId: res['userId']?.toString() ?? '',
            userName: res['userName']?.toString() ?? 'Student',
            isLead: false,
            subject: _activeSession!['subject'],
          ),
        ),
      ).then((_) => _checkActiveSession());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error'] ?? 'Could not join conference.')),
      );
      _checkActiveSession();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _topicController.dispose();
    _customSubjectController.dispose();
    super.dispose();
  }

    String _formatDateTime(String? dateStr) {
    if (dateStr == null) return 'Scheduled';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final weekday = days[dt.weekday - 1];
      final month = months[dt.month - 1];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final min = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$weekday, $month ${dt.day} • $hour:$min $ampm';
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading && _activeSession == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 1. ACTIVE WAITING FOR LEAD TO SCHEDULE
    if (_activeSession != null && _activeSession!['status'] == 'waiting') {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber.shade200, width: 2),
                ),
                child: const Icon(Icons.hourglass_top_rounded, size: 58, color: Colors.amber),
              ),
              const SizedBox(height: 24),
              const Text(
                'Doubt Request Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Waiting for Mentor Schedule',
                  style: TextStyle(color: Colors.brown.shade800, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book, size: 18, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(
                            _activeSession!['subject'] ?? 'General',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        _activeSession!['topic'] ?? '',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'A Lead Mentor will review your doubt and schedule a fixed conference time. You can check back here anytime.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: _cancelRequest,
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text('Cancel Request', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              ),
            ],
          ),
        ),
      );
    }

    // 2. ACTIVE SCHEDULED OR ONGOING APPOINTMENT
    if (_activeSession != null && (_activeSession!['status'] == 'scheduled' || _activeSession!['status'] == 'ongoing')) {
      final isOngoing = _activeSession!['status'] == 'ongoing';
      final canJoin = _activeSession!['canJoin'] == true || isOngoing;
      final startTimeStr = _formatDateTime(_activeSession!['scheduledStartTime']);

      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isOngoing ? Colors.green.shade50 : const Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOngoing ? Colors.green.shade300 : const Color(0xFFC7D2FE),
                    width: 2,
                  ),
                ),
                child: Icon(
                  isOngoing ? Icons.phone_in_talk : Icons.event_available,
                  size: 58,
                  color: isOngoing ? Colors.green : const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isOngoing ? 'Conference is Live Now!' : 'Session Scheduled!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Scheduled Time Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 8),
                    Text(
                      startTimeStr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Mentor Info Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color.fromARGB(255, 114, 155, 208),
                            child: Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _activeSession!['scheduledByName'] ?? 'Lead Mentor',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  _activeSession!['scheduledByRole'] ?? 'Lead',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Subject: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_activeSession!['subject'] ?? 'General'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Doubt: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(_activeSession!['topic'] ?? '')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (canJoin) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _joinConference,
                    icon: const Icon(Icons.video_call, color: Colors.white, size: 26),
                    label: const Text(
                      'Join Video Conference Now',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'The conference room will unlock 5 minutes before your scheduled appointment.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _cancelRequest,
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text('Cancel Appointment', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              ),
            ],
          ),
        ),
      );
    }

    // 3. NO ACTIVE CALL: FORM TO REQUEST NEW DOUBT SESSION
    return RefreshIndicator(
      onRefresh: () => _checkActiveSession(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informational Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Color(0xFF4F46E5), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.askDoubtsAnytimeTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.askDoubtsAnytimeSubtitle,
                          style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subject Selector
            Text(
              l10n.selectSubject,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedSubject,
                  items: _subjects.map((sub) {
                    return DropdownMenuItem(value: sub, child: Text(sub));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSubject = val);
                  },
                ),
              ),
            ),

            // Custom Subject Input if "Others" is selected
            if (_selectedSubject == 'Others') ...[
              const SizedBox(height: 14),
              Text(
                l10n.enterSubjectName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _customSubjectController,
                decoration: InputDecoration(
                  hintText: l10n.customSubjectHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Topic Description
            Text(
              l10n.describeYourDoubt,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _topicController,
              maxLines: 4,
              maxLength: 250,
              decoration: InputDecoration(
                hintText: l10n.describeYourDoubtHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 155, 208),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isLoading ? null : _submitRequest,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.video_call, color: Colors.white),
                label: Text(
                  _isLoading ? l10n.submitting : l10n.requestLiveCall,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideAppBar) {
      return _buildBody();
    }

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.liveVideoDoubtSolving),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }
}
