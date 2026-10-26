import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/doubt_provider.dart';
import 'package:unnati_app/models/doubt.dart';
import 'package:unnati_app/services/api_service.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class DoubtThreadScreen extends ConsumerStatefulWidget {
  final String doubtId;
  final bool isLeadView;
  final bool readOnly;

  const DoubtThreadScreen({
    super.key,
    required this.doubtId,
    this.isLeadView = false,
    this.readOnly = false,
  });

  @override
  ConsumerState<DoubtThreadScreen> createState() => _DoubtThreadScreenState();
}

class _DoubtThreadScreenState extends ConsumerState<DoubtThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  Timer? _autoRefreshTimer;
  bool _isSending = false;
  bool _isResolving = false;
  bool _isStudent = false;
  bool _canManageDoubts = false;
  String? _userId;
  StreamSubscription<Map<String, dynamic>?>? _userSub;

  @override
  void initState() {
    super.initState();
    _loadAuthContext();
    _userSub = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      final permissions = ApiService.permissionsFromUserData(user);
      setState(() {
        _userId = user == null
            ? null
            : (user['id']?.toString() ?? user['_id']?.toString());
        _isStudent = ApiService.isStudentUserData(user);
        _canManageDoubts =
            permissions.contains('REPLY_DOUBTS') ||
            permissions.contains('RESOLVE_DOUBTS');
      });

      // If this screen is lead-only and doubts permissions were revoked, close it.
      if (widget.isLeadView && !_canManageDoubts && !widget.readOnly) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.permissionrevoked),
            ),
          );
          Navigator.of(context).maybePop();
        }
      }
    });
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (_) {
      if (!mounted) return;
      _refresh();
    });
  }

  Future<void> _loadAuthContext() async {
    final user = await ApiService.getUserData();
    if (!mounted) return;
    final permissions = ApiService.permissionsFromUserData(user);
    setState(() {
      _userId = user == null
          ? null
          : (user['id']?.toString() ?? user['_id']?.toString());
      _isStudent = ApiService.isStudentUserData(user);
      _canManageDoubts =
          permissions.contains('REPLY_DOUBTS') ||
          permissions.contains('RESOLVE_DOUBTS');
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.messagemustbebetween5and300characters,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    if (widget.isLeadView && (!_canManageDoubts || widget.readOnly)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.permissionrevoked),
        ),
      );
      Navigator.of(context).maybePop();
      return;
    }

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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.doubtresolvedsuccessfully,
          ),
        ),
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.doubtthread)),
      body: detailsAsync.when(
        data: (doubt) {
          // If current user is a student and does not own this doubt, block access
          if (_isStudent &&
              _userId != null &&
              doubt.studentId != null &&
              doubt.studentId != _userId) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.youdonothavepermissiontoviewthisdoubt,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: Text(AppLocalizations.of(context)!.goback),
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
                      showResolve:
                          widget.isLeadView && _canManageDoubts && doubt.isOpen,
                      isResolving: _isResolving,
                      onResolve: _resolveDoubt,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _MessageBubble(message: messages[index]);
                        },
                      ),
                    ),
                    if (doubt.isOpen &&
                        (!widget.isLeadView ||
                            (_canManageDoubts && !widget.readOnly)))
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  maxLength: 300,
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.typeyourmessage,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: _isSending ? null : _sendMessage,
                                icon: _isSending
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          doubt.isOpen
                              ? 'Open doubts — only assigned leads can send messages.'
                              : 'This doubt is closed. You can no longer send messages.',
                          textAlign: TextAlign.center,
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
                    "Failed to load messages: $error",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          );
        },
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Failed to load doubt: $error", textAlign: TextAlign.center),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _refresh,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
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
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    doubt.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
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
            SizedBox(height: 6),
            Text(
              "Subject: ${doubt.subject.isEmpty ? 'General' : doubt.subject}",
            ),
            if (showResolve)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: isResolving ? null : onResolve,
                  icon: isResolving
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.check_circle_outline),
                  label: Text(AppLocalizations.of(context)!.resolve),
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
        ? Color(0xFF1F4A7A)
        : Color.fromARGB(255, 236, 236, 236);
    final textColor = isStudent ? Colors.white : Colors.black;

    return Align(
      alignment: isStudent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(10),
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
              "${message.senderName} (${message.senderRole})",
              style: TextStyle(
                color: textColor.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message.message,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 11,
              ),
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
    return '$day/$month $hour:$minute';
  }
}
