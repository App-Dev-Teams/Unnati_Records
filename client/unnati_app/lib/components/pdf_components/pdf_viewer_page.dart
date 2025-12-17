import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';

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
    return Scaffold(
      appBar: PdfAppBar(
        imageName: "unnatiLogoColourFix.png",
        name: title,
      ),
      body: SfPdfViewer.asset(
        pdfPath,
      ),
    );
  }
}
