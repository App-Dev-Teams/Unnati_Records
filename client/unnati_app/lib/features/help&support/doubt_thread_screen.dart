import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/doubt_provider.dart';
import 'package:unnati_app/models/doubt.dart';
import 'package:unnati_app/services/api_service.dart';

class DoubtThreadScreen extends ConsumerStatefulWidget {
  final String doubtId;
  final bool isLeadView;

  const DoubtThreadScreen({
    super.key,
    required this.doubtId,
    this.isLeadView = false,
  });

  @override
  ConsumerState<DoubtThreadScreen> createState() => _DoubtThreadScreenState();
}

class _DoubtThreadScreenState extends ConsumerState<DoubtThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  Timer? _autoRefreshTimer;
  bool _isSending = false;
  bool _isResolving = false;
  String? _role;
  String? _userId;
  StreamSubscription<Map<String, dynamic>?>? _userSub;

  @override
  void initState() {
    super.initState();
    _loadAuthContext();
    _userSub = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      setState(() {
        _userId = user == null
            ? null
            : (user['id']?.toString() ?? user['_id']?.toString());
        _role = user == null ? '' : (user['role'] as String? ?? '');
      });

      // If this screen is lead-only and the role was revoked, close it.
      if (widget.isLeadView && !(_role == 'lead' || _role == 'admin')) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Permission revoked.')));
          Navigator.of(context).maybePop();
        }
      }
    });
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      _refresh();
    });
  }

  Future<void> _loadAuthContext() async {
    final user = await ApiService.getUserData();
    final role = await ApiService.getRole();
    if (!mounted) return;
    setState(() {
      _userId = user == null
          ? null
          : (user['id']?.toString() ?? user['_id']?.toString());
      _role = role;
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _messageController.dispose();
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(doubtDetailsProvider(widget.doubtId));
    ref.invalidate(doubtMessagesProvider(widget.doubtId));
    ref.invalidate(myDoubtsProvider);
    ref.invalidate(openDoubtsProvider);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.length < 5 || text.length > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message must be between 5 and 300 characters.'),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final result = widget.isLeadView
        ? await ApiService.addDoubtReply(doubtId: widget.doubtId, message: text)
        : await ApiService.addDoubtMessage(
            doubtId: widget.doubtId,
            message: text,
          );

    if (!mounted) return;

    setState(() {
      _isSending = false;
    });

    if (result['success'] == true) {
      _messageController.clear();
      _refresh();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message']?.toString() ?? 'Failed to send message',
        ),
      ),
    );
  }

  Future<void> _resolveDoubt() async {
    setState(() {
      _isResolving = true;
    });

    final result = await ApiService.resolveDoubt(widget.doubtId);

    if (!mounted) return;

    setState(() {
      _isResolving = false;
    });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doubt resolved successfully.')),
      );
      _refresh();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message']?.toString() ?? 'Failed to resolve doubt',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(doubtDetailsProvider(widget.doubtId));
    final messagesAsync = ref.watch(doubtMessagesProvider(widget.doubtId));

    return Scaffold(
      appBar: AppBar(title: const Text('Doubt Thread')),
      body: detailsAsync.when(
        data: (doubt) {
          // If current user is a student and does not own this doubt, block access
          if ((_role ?? '') == 'student' &&
              _userId != null &&
              doubt.studentId != null &&
              doubt.studentId != _userId) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You do not have permission to view this doubt.',
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }
          return messagesAsync.when(
            data: (messages) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: Column(
                  children: [
                    _DoubtHeader(
                      doubt: doubt,
                      showResolve: widget.isLeadView && doubt.isOpen,
                      isResolving: _isResolving,
                      onResolve: _resolveDoubt,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _MessageBubble(message: messages[index]);
                        },
                      ),
                    ),
                    if (doubt.isOpen)
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  maxLength: 300,
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    hintText: 'Type your message',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: _isSending ? null : _sendMessage,
                                icon: _isSending
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'This doubt is closed. You can no longer send messages.',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              );
            },
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load messages: $error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load doubt: $error', textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _DoubtHeader extends StatelessWidget {
  final Doubt doubt;
  final bool showResolve;
  final bool isResolving;
  final VoidCallback onResolve;

  const _DoubtHeader({
    required this.doubt,
    required this.showResolve,
    required this.isResolving,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = doubt.isOpen ? Colors.green : Colors.red;
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    doubt.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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
            const SizedBox(height: 6),
            Text(
              'Subject: ${doubt.subject.isEmpty ? 'General' : doubt.subject}',
            ),
            if (showResolve)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: isResolving ? null : onResolve,
                  icon: isResolving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Text('Resolve'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final DoubtMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isStudent = message.isStudent;
    final bubbleColor = isStudent
        ? const Color(0xFF1F4A7A)
        : const Color.fromARGB(255, 236, 236, 236);
    final textColor = isStudent ? Colors.white : Colors.black;

    return Align(
      alignment: isStudent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${message.senderName} (${message.senderRole})',
              style: TextStyle(
                color: textColor.withOpacity(0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.message,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime? dt) {
    if (dt == null) return '--:--';
    final local = dt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month ${hour}:$minute';
  }
}
