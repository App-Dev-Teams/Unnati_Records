import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unnati_app/services/api_service.dart';

class CreateDoubtScreen extends StatefulWidget {
  const CreateDoubtScreen({super.key});

  @override
  State<CreateDoubtScreen> createState() => _CreateDoubtScreenState();
}

class _CreateDoubtScreenState extends State<CreateDoubtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();
  bool _isSubmitting = false;
  bool _isStudent = false;
  StreamSubscription<Map<String, dynamic>?>? _userSub;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subjectController.dispose();
    _userSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAuthContext();
    _userSub = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      final isStudent = ApiService.isStudentUserData(user);
      if (isStudent != _isStudent) {
        setState(() => _isStudent = isStudent);
        if (!isStudent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Not allowed'),
                content: const Text('Only students can create doubts.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        }
      }
    });
  }

  Future<void> _loadAuthContext() async {
    final user = await ApiService.getUserData();
    if (!mounted) return;
    setState(() => _isStudent = ApiService.isStudentUserData(user));
    if (!_isStudent) {
      // show message and close
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Not allowed'),
            content: const Text('Only students can create doubts.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).maybePop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final result = await ApiService.createDoubt(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      subject: _subjectController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doubt created successfully.')),
      );
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message']?.toString() ?? 'Failed to create doubt',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Doubt')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Title is required';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subjectController,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Subject is required';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 6,
              maxLines: 8,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.length < 5 || text.length > 300) {
                  return 'Description must be between 5 and 300 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit Doubt'),
            ),
          ],
        ),
      ),
    );
  }
}
