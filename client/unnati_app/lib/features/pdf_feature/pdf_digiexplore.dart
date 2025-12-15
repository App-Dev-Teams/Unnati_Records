import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unnati_app/Providers/download_provider.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/components/pdf_components/pdf_cards.dart';
import 'package:unnati_app/components/pdf_components/pdf_chaptercard.dart';
import 'package:unnati_app/components/pdf_components/pdf_viewer_page.dart';
import 'package:unnati_app/features/pdf_feature/pdf_mydownloads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class PdfDxscreen extends ConsumerStatefulWidget{
  @override
  ConsumerState<PdfDxscreen> createState() => _PdfDxscreenState();
}
class _PdfDxscreenState extends ConsumerState<PdfDxscreen>{
  @override
  void showDownloadPopup(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        "PDF downloaded successfully. You can view it in the Downloads section.",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "VIEW",
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PdfMydownloads(),
            ),
          );
        },
      ),
    ),
  );
}

  Widget build(BuildContext context){
    return Scaffold(
      appBar: PdfAppBar(imageName: "unnatiLogoColourFix.png", name: "DigiExplore Syllabus"),
      body:  SingleChildScrollView(child:  Column (children: [
       PdfModuleCard(
          icon: Icons.picture_as_pdf,
          iconColor: Colors.redAccent,
          title: 'Module 1: Basics of Computing',
       ),
       Row(
       children: [
        SizedBox(width: 20,),
        PdfChapterCard(icon: FontAwesomeIcons.desktop, title: "Computer Basics",  onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/chapter1b.pdf',
                title: 'Computer Basics',
              ),
            ),);
        }, onDownload: (){
          ref.read(dP.notifier).adddownload(DownloadPdf(title: "Computer Basics", path: 'assets/pdfs/chapter1b.pdf'));
          showDownloadPopup(context);
        },),
        PdfChapterCard(icon: FontAwesomeIcons.computer, title: "History Of Computers", onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/chapter1b.pdf',
                title: 'History Of Computers',
              ),
            ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "History Of Computers", path: 'assets/pdfs/chapter1b.pdf'));
        showDownloadPopup(context);},),
       ]
       ),
       PdfModuleCard(
          icon: Icons.picture_as_pdf,
          iconColor: Colors.redAccent,
          title: 'Module 2: Microsoft Office',
       ),
       Row(
       children: [
        SizedBox(width: 20,),
        PdfChapterCard(icon: FontAwesomeIcons.paintbrush, title: "MS PAINT",  onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/mspaint.pdf',
                title: 'MS PAINT',
              ),
            ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "MS PAINT", path: 'assets/pdfs/mspaint.pdf'));
        showDownloadPopup(context); showDownloadPopup(context);},),
        PdfChapterCard(icon: FontAwesomeIcons.fileWord, title: "MS WORD", onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/word+docs.pdf',
                title: 'MS WORD',
              ),
            ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "MS WORD", path: 'assets/pdfs/word+docs.pdf'));
        showDownloadPopup(context);},),
       ]
       ),
       Row(
       children: [
        SizedBox(width: 20,),
        PdfChapterCard(icon: FontAwesomeIcons.fileLines, title: "MS WORD AND GOOGLE DOCS",  onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/word+docs.pdf',
                title: 'MS WORD+GOOGLE DOCS',
              ),
            ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "MS WORD AND GOOGLE DOCS", path: 'assets/pdfs/word+docs.pdf'));
            showDownloadPopup(context);},),
        PdfChapterCard(icon: FontAwesomeIcons.fileExcel, title: "MS EXCEL", onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/excel.pdf',
                title: 'MS EXCEL',
              ),
            ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "MS EXCEL", path: 'assets/pdfs/excel.pdf'));
          showDownloadPopup(context);},),
       ]
       ),
       PdfModuleCard(
          icon: Icons.picture_as_pdf,
          iconColor: Colors.redAccent,
          title: 'Module 3: Internet',
       ),
       PdfChapterCard(icon: FontAwesomeIcons.earthAsia, title: "Internet Usage", onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                pdfPath: 'assets/pdfs/internet.pdf',
                title: 'Internet Usage',
              ),
            ),);
       }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "Internet Usage", path: 'assets/pdfs/internet.pdf'));
       showDownloadPopup(context);},),
       PdfModuleCard(
          icon: Icons.picture_as_pdf,
          iconColor: Colors.redAccent,
          title: 'Module 4: Cyber Security',
       ),
       Row(
       children: [
        SizedBox(width: 20,),
        PdfChapterCard(icon: FontAwesomeIcons.chrome, title: "CyberSecurity",  onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerPage(
                  pdfPath: 'assets/pdfs/CyberSecurity.pdf',
                  title: 'CyberSecurity',
                ),
              ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "CyberSecurity", path: 'assets/pdfs/CyberSecurity.pdf'));
        showDownloadPopup(context);
        },),
        PdfChapterCard(icon: FontAwesomeIcons.magnifyingGlass, title: "Detect Scam Messages", onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerPage(
                  pdfPath: 'assets/pdfs/detectspam.pdf',
                  title: 'Detect Scam Messages',
                ),
              ),);
        }, onDownload: (){ref.read(dP.notifier).adddownload(DownloadPdf(title: "Detect Scam Messages", path: 'assets/pdfs/detectspam.pdf'));
        showDownloadPopup(context);
        },),
       ]
       ),


      ],),)
    );
  }
}
