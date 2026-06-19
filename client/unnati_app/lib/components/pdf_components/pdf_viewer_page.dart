import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'dart:io';

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;
  final String title;

  const PdfViewerPage({
    super.key,
    required this.pdfPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        pdfPath.startsWith('http://') || pdfPath.startsWith('https://');

    return Scaffold(
      appBar: PdfAppBar(
        imageName: "NGO.png",
        name: title,
      ),
      body: isNetwork 
          ? SfPdfViewer.network(pdfPath)
          : SfPdfViewer.file(File(pdfPath)),
    );
  }
}
