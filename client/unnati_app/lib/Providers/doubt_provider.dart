import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/models/doubt.dart';
import 'package:unnati_app/services/api_service.dart';

/// Real-time stream provider for student's own doubts
final myDoubtsStreamProvider = StreamProvider.autoDispose<List<Doubt>>((ref) async* {
  try {
    final initial = await ApiService.getMyDoubts();
    yield initial.map(Doubt.fromJson).toList();
  } catch (e) {
    rethrow;
  }

  final stream = Stream.periodic(const Duration(seconds: 4));
  await for (final _ in stream) {
    try {
      final doubts = await ApiService.getMyDoubts();
      yield doubts.map(Doubt.fromJson).toList();
    } catch (_) {}
  }
});

final myDoubtsProvider = myDoubtsStreamProvider;

/// Real-time stream provider for open doubts (volunteer side)
final openDoubtsStreamProvider = StreamProvider.autoDispose<List<Doubt>>((ref) async* {
  try {
    final initial = await ApiService.getOpenDoubts();
    yield initial.map(Doubt.fromJson).toList();
  } catch (e) {
    rethrow;
  }

  final stream = Stream.periodic(const Duration(seconds: 4));
  await for (final _ in stream) {
    try {
      final doubts = await ApiService.getOpenDoubts();
      yield doubts.map(Doubt.fromJson).toList();
    } catch (_) {}
  }
});

final openDoubtsProvider = openDoubtsStreamProvider;

/// Real-time stream provider for closed doubts (volunteer side)
final closedDoubtsStreamProvider = StreamProvider.autoDispose<List<Doubt>>((ref) async* {
  try {
    final initial = await ApiService.getClosedDoubts();
    yield initial.map(Doubt.fromJson).toList();
  } catch (e) {
    rethrow;
  }

  final stream = Stream.periodic(const Duration(seconds: 4));
  await for (final _ in stream) {
    try {
      final doubts = await ApiService.getClosedDoubts();
      yield doubts.map(Doubt.fromJson).toList();
    } catch (_) {}
  }
});

final closedDoubtsProvider = closedDoubtsStreamProvider;

/// Real-time stream provider for a doubt's details and resolution status
final doubtDetailsStreamProvider = StreamProvider.autoDispose
    .family<Doubt, String>((ref, doubtId) async* {
  try {
    final initial = await ApiService.getDoubtDetails(doubtId);
    yield Doubt.fromJson(initial);
  } catch (e) {
    rethrow;
  }

  final stream = Stream.periodic(const Duration(seconds: 3));
  await for (final _ in stream) {
    try {
      final doubt = await ApiService.getDoubtDetails(doubtId);
      yield Doubt.fromJson(doubt);
    } catch (_) {}
  }
});

final doubtDetailsProvider = doubtDetailsStreamProvider;

/// Real-time stream provider for doubt chat messages (both student and volunteer side)
final doubtMessagesStreamProvider = StreamProvider.autoDispose
    .family<List<DoubtMessage>, String>((ref, doubtId) async* {
  try {
    final initial = await ApiService.getDoubtMessages(doubtId);
    yield initial.map(DoubtMessage.fromJson).toList();
  } catch (e) {
    rethrow;
  }

  final stream = Stream.periodic(const Duration(seconds: 2));
  await for (final _ in stream) {
    try {
      final messages = await ApiService.getDoubtMessages(doubtId);
      yield messages.map(DoubtMessage.fromJson).toList();
    } catch (_) {}
  }
});

final doubtMessagesProvider = doubtMessagesStreamProvider;
