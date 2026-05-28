import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/services/download_service.dart';
import 'package:unnati_app/services/database_service.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mydownloads.dart';
import 'dart:io';

class DownloadButton extends StatefulWidget {
  final String fileUrl;
  final String fileName;
  final String fileType; // 'pdf' or 'image'
  final Function(DownloadPdf) onDownloadComplete;
  final Function(String) onError;
  final VoidCallback? onDownloadStart;

  const DownloadButton({
    Key? key,
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    required this.onDownloadComplete,
    required this.onError,
    this.onDownloadStart,
  }) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  final DownloadService _downloadService = DownloadService();
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return isDownloading
        ? _buildDownloadingState()
        : _buildDownloadButton();
  }

  /// Build the download button
  Widget _buildDownloadButton() {
    return InkWell(
      onTap: _handleDownload,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A7CF7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.download_rounded,
          color: Color(0xFF4A7CF7),
          size: 20,
        ),
      ),
    );
  }

  /// Build downloading state with progress indicator
  Widget _buildDownloadingState() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF4A7CF7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 20,
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                value: downloadProgress,
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF4A7CF7).withOpacity(0.8),
                ),
              ),
            ),
            Text(
              '${(downloadProgress * 100).toInt()}%',
              style: GoogleFonts.nunito(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A7CF7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle download logic
  Future<void> _handleDownload() async {
    try {
      // Callback for download start
      widget.onDownloadStart?.call();

      setState(() {
        isDownloading = true;
        downloadProgress = 0.0;
      });

      // Request permission
      final hasPermission = await _downloadService.requestStoragePermission();
      if (!hasPermission) {
        if (mounted) {
          widget.onError('Storage permission denied');
          setState(() => isDownloading = false);
        }
        return;
      }

      // Generate unique filename
      final uniqueFileName = DownloadService.generateUniqueFileName(widget.fileName);

      // Download file with progress
      final filePath = await _downloadService.downloadFile(
        fileUrl: widget.fileUrl,
        fileName: uniqueFileName,
        onProgress: (received, total) {
          setState(() {
            downloadProgress = total > 0 ? received / total : 0.0;
          });
        },
      );

      if (filePath == null) {
        if (mounted) {
          widget.onError('Failed to download file');
          setState(() => isDownloading = false);
        }
        return;
      }

      // Get file size
      final fileSize = await _downloadService.getFileSize(filePath);

      // Create DownloadPdf object
      final downloadPdf = DownloadPdf(
        title: widget.fileName,
        path: filePath,
        fileUrl: widget.fileUrl,
        fileType: widget.fileType,
        downloadedAt: DateTime.now().toString(),
        fileSize: fileSize,
        isLocal: true,
      );

      // Callback for successful download
      if (mounted) {
        widget.onDownloadComplete(downloadPdf);
        setState(() => isDownloading = false);
      }
    } catch (e) {
      print('Download error: $e');
      if (mounted) {
        widget.onError('Download error: $e');
        setState(() => isDownloading = false);
      }
    }
  }
}

/// Helper method to show download dialog
Future<void> showDownloadDialog(
  BuildContext context, {
  required String fileUrl,
  required String fileName,
  required String fileType,
  required Function(DownloadPdf) onDownloadComplete,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _DownloadProgressDialog(
        fileUrl: fileUrl,
        fileName: fileName,
        fileType: fileType,
        onDownloadComplete: onDownloadComplete,
      );
    },
  );
}

/// Download progress dialog
class _DownloadProgressDialog extends StatefulWidget {
  final String fileUrl;
  final String fileName;
  final String fileType;
  final Function(DownloadPdf) onDownloadComplete;

  const _DownloadProgressDialog({
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    required this.onDownloadComplete,
  });

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  late Future<void> _downloadFuture;
  double _progress = 0.0;
  String _status = 'Preparing download...';
  final DownloadService _downloadService = DownloadService();

  @override
  void initState() {
    super.initState();
    _downloadFuture = _performDownload();
  }

  Future<void> _performDownload() async {
    try {
      final hasPermission = await _downloadService.requestStoragePermission();
      if (!hasPermission) {
        _updateStatus('Permission denied');
        return;
      }

      _updateStatus('Starting download...');

      final uniqueFileName =
          DownloadService.generateUniqueFileName(widget.fileName);

      final filePath = await _downloadService.downloadFile(
        fileUrl: widget.fileUrl,
        fileName: uniqueFileName,
        onProgress: (received, total) {
          _updateProgress(received, total);
        },
      );

      if (filePath == null) {
        _updateStatus('Download failed');
        return;
      }

      _updateStatus('Getting file info...');

      final fileSize = await _downloadService.getFileSize(filePath);

      final downloadPdf = DownloadPdf(
        title: widget.fileName,
        path: filePath,
        fileUrl: widget.fileUrl,
        fileType: widget.fileType,
        downloadedAt: DateTime.now().toString(),
        fileSize: fileSize,
        isLocal: true,
      );

      _updateStatus('Download complete!');

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        widget.onDownloadComplete(downloadPdf);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Download error: $e');
      _updateStatus('Error: $e');
    }
  }

  void _updateProgress(int received, int total) {
    if (mounted) {
      setState(() {
        _progress = total > 0 ? received / total : 0.0;
        _status =
            'Downloading... ${(received / (1024 * 1024)).toStringAsFixed(2)} MB / ${(total / (1024 * 1024)).toStringAsFixed(2)} MB';
      });
    }
  }

  void _updateStatus(String status) {
    if (mounted) {
      setState(() => _status = status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Download Progress',
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.fileName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF4A7CF7),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _status,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _progress == 1.0
              ? () => Navigator.of(context).pop()
              : null,
          child: Text(
            'Close',
            style: GoogleFonts.nunito(
              color: _progress == 1.0
                  ? const Color(0xFF4A7CF7)
                  : const Color(0xFFB0B9C1),
            ),
          ),
        ),
      ],
    );
  }
}
