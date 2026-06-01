import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mydownloads.dart';
import 'package:unnati_app/services/database_service.dart';

final dP = StateNotifierProvider<DownloadProvider, List<DownloadPdf>>(
  (ref) => DownloadProvider(),
);

class DownloadProvider extends StateNotifier<List<DownloadPdf>> {
  final DatabaseService _dbService = DatabaseService();

  DownloadProvider() : super([]) {
    _initializeDownloads();
  }

  /// Initialize downloads from database on startup
  Future<void> _initializeDownloads() async {
    try {
      final downloads = await _dbService.getAllDownloads();
      final downloadPdfs = downloads
          .map((download) => DownloadPdf(
                id: download.id,
                title: download.title,
                path: download.filePath,
                fileUrl: download.fileUrl,
                fileType: download.fileType,
                downloadedAt: download.downloadedAt,
                fileSize: download.fileSize,
                isLocal: true,
              ))
          .toList();

      state = downloadPdfs;
    } catch (e) {
      print('Error initializing downloads: $e');
    }
  }

  /// Add a new download to provider and database
  Future<void> addDownload(DownloadPdf pdf) async {
    try {
      // Check if already exists
      if (state.any((e) => e.title == pdf.title && e.path == pdf.path)) {
        return;
      }

      // Add to database
      final download = Download(
        title: pdf.title,
        filePath: pdf.path,
        fileUrl: pdf.fileUrl,
        downloadedAt: pdf.downloadedAt,
        fileSize: pdf.fileSize,
        fileType: pdf.fileType,
      );

      final id = await _dbService.insertDownload(download);
      final pdfWithId = pdf.copyWith(id: id);

      // Update state
      state = [...state, pdfWithId];
    } catch (e) {
      print('Error adding download: $e');
    }
  }

  /// Remove a download from provider and database
  Future<void> removeDownload(int? id, String title, String path) async {
    try {
      if (id != null) {
        await _dbService.deleteDownload(id);
      }

      // Update state
      state = state.where((e) => !(e.title == title && e.path == path)).toList();
    } catch (e) {
      print('Error removing download: $e');
    }
  }

  /// Refresh downloads from database
  Future<void> refreshDownloads() async {
    await _initializeDownloads();
  }

  /// Get downloads by type
  Future<List<DownloadPdf>> getDownloadsByType(String fileType) async {
    try {
      final downloads = await _dbService.getDownloadsByType(fileType);
      return downloads
          .map((download) => DownloadPdf(
                id: download.id,
                title: download.title,
                path: download.filePath,
                fileUrl: download.fileUrl,
                fileType: download.fileType,
                downloadedAt: download.downloadedAt,
                fileSize: download.fileSize,
                isLocal: true,
              ))
          .toList();
    } catch (e) {
      print('Error getting downloads by type: $e');
      return [];
    }
  }

  /// Search downloads
  Future<List<DownloadPdf>> searchDownloads(String query) async {
    try {
      final downloads = await _dbService.searchDownloads(query);
      return downloads
          .map((download) => DownloadPdf(
                id: download.id,
                title: download.title,
                path: download.filePath,
                fileUrl: download.fileUrl,
                fileType: download.fileType,
                downloadedAt: download.downloadedAt,
                fileSize: download.fileSize,
                isLocal: true,
              ))
          .toList();
    } catch (e) {
      print('Error searching downloads: $e');
      return [];
    }
  }
}
