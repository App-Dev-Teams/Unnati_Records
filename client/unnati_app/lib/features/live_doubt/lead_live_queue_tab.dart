import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/features/live_doubt/live_video_conference_screen.dart';

class LeadLiveQueueTab extends StatefulWidget {
  final bool hideAppBar;
  const LeadLiveQueueTab({super.key, this.hideAppBar = false});

  @override
  State<LeadLiveQueueTab> createState() => _LeadLiveQueueTabState();
}

class _LeadLiveQueueTabState extends State<LeadLiveQueueTab> {
  List<dynamic> _waitingList = [];
  List<dynamic> _scheduledList = [];
  List<dynamic> _ongoingList = [];
  bool _isLoading = true;
  bool _isCheckingRole = true;
  bool _hasAccess = false;
  String? _userRole;
  String? _userId;
  String? _errorMessage;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _verifyAccess();
  }

  Future<void> _verifyAccess() async {
    setState(() => _isCheckingRole = true);
    final role = await ApiService.getRole();
    final userData = await ApiService.getUserData();
    final effectiveRole = role ?? userData?['role']?.toString() ?? '';
    final lowerRole = effectiveRole.trim().toLowerCase();

    final isLeadOrAdmin = lowerRole == 'admin' ||
        lowerRole.contains('lead') ||
        lowerRole.startsWith('js-') ||
        lowerRole.contains('secretary');

    if (!mounted) return;

    setState(() {
      _userRole = effectiveRole.isNotEmpty ? effectiveRole : 'Volunteer';
      _userId = userData?['_id']?.toString() ?? userData?['id']?.toString();
      _hasAccess = isLeadOrAdmin;
      _isCheckingRole = false;
    });

    _refreshTimer?.cancel();
    if (isLeadOrAdmin) {
      _fetchQueue();
      // Poll queue every 6 seconds for leads/admin
      _refreshTimer = Timer.periodic(const Duration(seconds: 6), (_) {
        if (mounted) _fetchQueue(silent: true);
      });
    }
  }

  Future<void> _fetchQueue({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    final res = await ApiService.getLiveQueue();
    if (!mounted) return;

    if (res['success'] == true) {
      setState(() {
        final rawScheduled = (res['scheduled'] as List<dynamic>?) ?? [];
        final now = DateTime.now();
        // Remove scheduled conferences if more than 1 hour has elapsed since scheduled start time
        final filteredScheduled = rawScheduled.where((item) {
          final startStr = item['scheduledStartTime']?.toString();
          if (startStr == null) return false;
          try {
            final start = DateTime.parse(startStr).toLocal();
            return now.difference(start).inMinutes < 60;
          } catch (_) {
            return true;
          }
        }).toList();

        _waitingList = res['waiting'] ?? [];
        _scheduledList = filteredScheduled;
        _ongoingList = res['ongoing'] ?? [];
        _errorMessage = null;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = res['error']?.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openScheduleDialog(Map<String, dynamic> item) async {
    final sessionId = item['_id'];
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
      DateTime.now().add(const Duration(minutes: 15)),
    );
    int selectedDuration = 30;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: const [
                  Icon(Icons.schedule, color: Color(0xFF4F46E5)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Set Conference Schedule',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student: ${item['studentName']} (${item['studentClass'] != null ? 'Class ${item['studentClass']}' : ''})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Subject: ${item['subject']}',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Doubt: "${item['topic']}"',
                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                    ),
                    const Divider(height: 24),

                    // Date Selection
                    const Text('Select Date:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 14)),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Time Selection
                    const Text('Select Start Time:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null) {
                            setDialogState(() => selectedTime = picked);
                          }
                        },
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(selectedTime.format(context)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Duration Selection (ChoiceChips in Wrap: zero overflow, 1-tap select)
                    const Text('Duration:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        {'mins': 15, 'label': '15 min'},
                        {'mins': 30, 'label': '30 min (Rec.)'},
                        {'mins': 45, 'label': '45 min'},
                        {'mins': 60, 'label': '60 min'},
                      ].map((d) {
                        final mins = d['mins'] as int;
                        final label = d['label'] as String;
                        final isSelected = selectedDuration == mins;
                        return ChoiceChip(
                          label: Text(label),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF1E293B),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF4F46E5),
                          backgroundColor: const Color(0xFFF1F5F9),
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setDialogState(() => selectedDuration = mins);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                  ),
                  onPressed: () async {
                    final startDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    Navigator.pop(dialogContext);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );

                    final res = await ApiService.scheduleLiveCall(
                      sessionId,
                      startDateTime,
                      durationMinutes: selectedDuration,
                    );

                    if (!mounted) return;
                    Navigator.pop(context); // close loader

                    if (res['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res['message'] ?? 'Conference scheduled successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _fetchQueue();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res['error'] ?? 'Could not schedule conference.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      _fetchQueue();
                    }
                  },
                  child: const Text('Confirm Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _startConference(Map<String, dynamic> item) async {
    final sessionId = item['_id'];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final res = await ApiService.startLiveCall(sessionId);
    if (!mounted) return;
    Navigator.pop(context); // close loader

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
            userName: res['userName']?.toString() ?? 'Lead Mentor',
            isLead: true,
            studentName: item['studentName'],
            subject: item['subject'],
          ),
        ),
      ).then((_) {
        _fetchQueue();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['error'] ?? 'Could not start conference.'),
          backgroundColor: Colors.red,
        ),
      );
      _fetchQueue();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
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

  Widget _buildRestrictedAccessView() {
    return RefreshIndicator(
      onRefresh: () => _verifyAccess(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 242, 255),
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromARGB(255, 199, 210, 254), width: 2),
              ),
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                size: 64,
                color: Color.fromARGB(255, 79, 70, 229),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Leads & Admin Access Only',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            'Live 1-to-1 video doubt sessions can only be scheduled and accepted by Unnati Leads and Admins.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline, size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  'Your Role: ${_userRole ?? "Volunteer"}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _verifyAccess(),
              icon: const Icon(Icons.refresh),
              label: const Text('Re-check Role'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isCheckingRole) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasAccess) {
      return _buildRestrictedAccessView();
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => _fetchQueue(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_errorMessage != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    onPressed: () => _fetchQueue(),
                  )
                ],
              ),
            ),
          ],

          // 1. PENDING REQUESTS WAITING TO BE SCHEDULED
          Row(
            children: [
              const Text(
                'Incoming Doubt Requests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_waitingList.length}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_waitingList.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.mark_chat_read_outlined, size: 42, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  const Text(
                    'No new doubt requests waiting for schedule.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          else
            ..._waitingList.map((item) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color.fromARGB(255, 114, 155, 208),
                                  child: Icon(Icons.person, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['studentName'] ?? 'Student',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      if (item['studentClass'] != null)
                                        Text(
                                          'Class: ${item['studentClass']}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              item['subject'] ?? 'General',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.blue.shade50,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Doubt: ${item['topic']}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _openScheduleDialog(item),
                          icon: const Icon(Icons.event_available, color: Colors.white, size: 20),
                          label: const Text(
                            'Set Schedule Time',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 16),

          // 2. SCHEDULED SESSIONS
          Row(
            children: [
              const Text(
                'Scheduled Conferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_scheduledList.length}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_scheduledList.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Text(
                'No scheduled conferences upcoming.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            )
          else
            ..._scheduledList.map((item) {
              final isAssignedToMe = item['scheduledBy'] != null &&
                  _userId != null &&
                  item['scheduledBy'].toString() == _userId;
              final leadName = item['scheduledByName'] ?? 'Lead';
              final leadRole = item['scheduledByRole'] ?? 'Lead';
              final timeStr = _formatDateTime(item['scheduledStartTime']);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isAssignedToMe ? Colors.green.shade300 : Colors.indigo.shade200,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Student + Subject
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['studentName'] ?? 'Student',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              item['subject'] ?? 'General',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.blue.shade50,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Doubt: ${item['topic']}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const Divider(height: 20),

                      // Scheduled Time Row
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Color(0xFF4F46E5)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              timeStr,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Assigned Lead Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isAssignedToMe ? Colors.green.shade50 : Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isAssignedToMe ? Colors.green.shade300 : Colors.indigo.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isAssignedToMe ? Icons.check_circle : Icons.person_pin,
                              size: 16,
                              color: isAssignedToMe ? Colors.green : const Color(0xFF4F46E5),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isAssignedToMe
                                    ? 'Appointed to You ($leadName)'
                                    : 'Appointed to: $leadName ($leadRole)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isAssignedToMe ? Colors.green.shade900 : const Color(0xFF4F46E5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Start / Join Call Button
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAssignedToMe ? Colors.green : Colors.blueGrey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _startConference(item),
                          icon: const Icon(Icons.video_call, color: Colors.white, size: 20),
                          label: Text(
                            isAssignedToMe ? 'Start / Join Conference' : 'Join Conference Room',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

          // 3. ONGOING SESSIONS
          if (_ongoingList.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Active Conferences (Live Now)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._ongoingList.map((item) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.green.shade300),
                ),
                child: ListTile(
                  leading: const Icon(Icons.phone_in_talk, color: Colors.green),
                  title: Text('${item['studentName']} (${item['subject']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Mentor: ${item['scheduledByName'] ?? item['acceptedByName'] ?? "Lead"}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _startConference(item),
                    child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideAppBar) {
      return _buildBody();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Requests',
            onPressed: () => _fetchQueue(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
