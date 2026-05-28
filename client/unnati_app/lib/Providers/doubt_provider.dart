import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/models/doubt.dart';
import 'package:unnati_app/services/api_service.dart';

final myDoubtsProvider = FutureProvider.autoDispose<List<Doubt>>((ref) async {
  final doubts = await ApiService.getMyDoubts();
  return doubts.map(Doubt.fromJson).toList();
});

final openDoubtsProvider = FutureProvider.autoDispose<List<Doubt>>((ref) async {
  final doubts = await ApiService.getOpenDoubts();
  return doubts.map(Doubt.fromJson).toList();
});

final doubtDetailsProvider = FutureProvider.autoDispose.family<Doubt, String>((
  ref,
  doubtId,
) async {
  final doubt = await ApiService.getDoubtDetails(doubtId);
  return Doubt.fromJson(doubt);
});

final doubtMessagesProvider = FutureProvider.autoDispose
    .family<List<DoubtMessage>, String>((ref, doubtId) async {
      final messages = await ApiService.getDoubtMessages(doubtId);
      return messages.map(DoubtMessage.fromJson).toList();
    });
