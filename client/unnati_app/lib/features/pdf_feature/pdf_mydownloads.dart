import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/Providers/download_provider.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/components/pdf_components/pdf_downloadcard.dart';
import 'package:unnati_app/components/pdf_components/pdf_viewer_page.dart';
import 'package:unnati_app/services/download_service.dart';

class PdfMydownloads extends ConsumerStatefulWidget {
  const PdfMydownloads({super.key});

  @override
  ConsumerState<PdfMydownloads> createState() => _PdfMydownloadsState();
}

class _PdfMydownloadsState extends ConsumerState<PdfMydownloads> {
  final DownloadService _downloadService = DownloadService();

  @override
  Widget build(BuildContext context) {
    final downloads = ref.watch(dP);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          PdfAppBar(imageName: "unnatiLogoColourFix.png", name: "My Downloads"),
      body: downloads.isEmpty
          ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset("assets/lottie/empty.json")),
          Text('No downloads yet',style: GoogleFonts.oswald(fontSize: 20,fontWeight: FontWeight.bold),),
        ],
      ))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: downloads.length,
              itemBuilder: (BuildContext context, int index) {
                final item = downloads[index];
                return _buildDownloadTile(context, item);
              },
            ),
    );
  }

  /// Build each download tile with delete option
  Widget _buildDownloadTile(BuildContext context, DownloadPdf item) {
    return Stack(
      children: [
        // Main PDF Card
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerPage(
                  pdfPath: item.path,
                  title: item.title,
                ),
              ),
            );
          },
          child: PdfChapterCardSimple(
            icon: Icons.picture_as_pdf,
            title: item.title,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                    pdfPath: item.path,
                    title: item.title,
                  ),
                ),
              );
            },
          ),
        ),
        // Delete Button (Top Right Corner)
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showDeleteConfirmation(context, item),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, DownloadPdf item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Download?',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${item.title}"?\n\nThis action cannot be undone.',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            ),
            // Delete Button
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteDownload(item);
              },
              child: Text(
                'Delete',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  /// Delete download file and remove from database
  Future<void> _deleteDownload(DownloadPdf item) async {
    try {
      // Delete file from device storage
      await _downloadService.deleteFile(item.path);

      // Remove from provider and database
      await ref.read(dP.notifier).removeDownload(
            item.id,
            item.title,
            item.path,
          );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} deleted successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

class DownloadPdf {
  final int? id;
  final String title;
  final String path;
  final String fileUrl;
  final String fileType; // 'pdf' or 'image'
  final String downloadedAt;
  final String fileSize;
  final bool isLocal;

  DownloadPdf({
    this.id,
    required this.title,
    required this.path,
    required this.fileUrl,
    required this.fileType,
    required this.downloadedAt,
    required this.fileSize,
    this.isLocal = true,
  });

  /// Convert DownloadPdf to Map for easy manipulation
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'downloadedAt': downloadedAt,
      'fileSize': fileSize,
      'isLocal': isLocal ? 1 : 0,
    };
  }

  /// Create copy with modified fields
  DownloadPdf copyWith({
    int? id,
    String? title,
    String? path,
    String? fileUrl,
    String? fileType,
    String? downloadedAt,
    String? fileSize,
    bool? isLocal,
  }) {
    return DownloadPdf(
      id: id ?? this.id,
      title: title ?? this.title,
      path: path ?? this.path,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      fileSize: fileSize ?? this.fileSize,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}