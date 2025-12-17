import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mydownloads.dart';
final dP = StateNotifierProvider<DownloadProvider, List<DownloadPdf>>((ref) => DownloadProvider(),);
class DownloadProvider extends StateNotifier<List<DownloadPdf>>{
  DownloadProvider() : super([]);
  void adddownload(DownloadPdf pdf){
    if(state.any((e) => e.title==pdf.title && e.path==pdf.path)) return;// null return kr dera agar already exist krta h
    state = state + [pdf];//array me pdf add krdi
  }
}