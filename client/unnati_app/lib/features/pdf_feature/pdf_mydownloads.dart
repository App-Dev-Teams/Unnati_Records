import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unnati_app/Providers/download_provider.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/components/pdf_components/pdf_chaptercard.dart';
import 'package:unnati_app/components/pdf_components/pdf_downloadcard.dart';
import 'package:unnati_app/components/pdf_components/pdf_viewer_page.dart';

class PdfMydownloads extends ConsumerStatefulWidget {
  const PdfMydownloads({super.key});

  @override
  ConsumerState<PdfMydownloads> createState() => _PdfMydownloadsState();
}

class _PdfMydownloadsState extends ConsumerState<PdfMydownloads> {
  @override
  Widget build(BuildContext context) {
    final downloads = ref.watch(dP);

    return Scaffold(
      appBar:
          PdfAppBar(imageName: "unnatiLogoColourFix.png", name: "My Downloads"),
      body: downloads.isEmpty
          ? const Center(child: Text("No Downloads Yet"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: downloads.length,
              itemBuilder: (BuildContext context, int index) {
                final item = downloads[index];
                return PdfChapterCardSimple(
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
                );
              },
            ),
    );
  }
}

class DownloadPdf {
  String title;
  String path;

  DownloadPdf({required this.title, required this.path});
}