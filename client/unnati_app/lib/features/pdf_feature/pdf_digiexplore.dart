import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/components/pdf_components/pdf_appbar.dart';
import 'package:unnati_app/components/pdf_components/pdf_viewer_page.dart';
import 'package:unnati_app/services/api_service.dart';

class PdfDxscreen extends StatefulWidget {
  const PdfDxscreen({super.key});

  @override
  State<PdfDxscreen> createState() => _PdfDxscreenState();
}

class _PdfDxscreenState extends State<PdfDxscreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> folders = [];
  final Map<String, List<Map<String, dynamic>>> folderFiles = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedFolders = await ApiService.fetchFolders();
      final filesMap = <String, List<Map<String, dynamic>>>{};

      for (final folder in fetchedFolders) {
        final folderId = (folder['_id'] ?? '').toString();
        if (folderId.isEmpty) continue;
        try {
          filesMap[folderId] = await ApiService.fetchFilesByFolder(folderId);
        } catch (_) {
          filesMap[folderId] = [];
        }
      }

      if (!mounted) return;
      setState(() {
        folders = fetchedFolders;
        folderFiles
          ..clear()
          ..addAll(filesMap);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load DigiExplore data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _openPdf(Map<String, dynamic> file) {
    final link = (file['link'] ?? '').toString();
    final title = (file['displayName'] ?? 'PDF').toString();

    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid file link')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(
          pdfPath: link,
          title: title,
        ),
      ),
    );
  }

  Color _accent(int index) {
    const colors = [
      Color(0xFF2B3D54),
      Color(0xFF4A7CF7),
      Color(0xFF0EA5A6),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
    ];
    return colors[index % colors.length];
  }

  Widget _buildFileTile(Map<String, dynamic> file) {
    final title = (file['displayName'] ?? 'Untitled').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openPdf(file),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B3D54).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  FontAwesomeIcons.filePdf,
                  color: Color(0xFF2B3D54),
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to open the PDF',
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolderCard(Map<String, dynamic> folder, int index) {
    final folderId = (folder['_id'] ?? '').toString();
    final folderName = (folder['name'] ?? 'Untitled').toString();
    final className = (folder['className'] ?? '').toString();
    final files = folderFiles[folderId] ?? [];
    final accent = _accent(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: const Color(0xFF2B3D54),
          collapsedIconColor: const Color(0xFF2B3D54),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.12), accent.withOpacity(0.24)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.folder_rounded,
              color: accent,
              size: 27,
            ),
          ),
          title: Text(
            folderName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: const Color(0xFF111827),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Class $className • ${files.length} file${files.length == 1 ? '' : 's'}',
              style: GoogleFonts.nunito(
                color: const Color(0xFF6B7280),
                fontSize: 13,
              ),
            ),
          ),
          children: [
            if (files.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  'No files uploaded in this folder yet',
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              )
            else
              Column(
                children: files.map(_buildFileTile).toList(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalFiles = folderFiles.values.fold<int>(
      0,
      (sum, files) => sum + files.length,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: PdfAppBar(
        imageName: 'unnatiLogoColourFix.png',
        name: 'DigiExplore Syllabus',
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF2B3D54),
        backgroundColor: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF111212),
                              Color(0xFF1E2A3A),
                              Color(0xFF2B3D54),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.14),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.menu_book_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DigiExplore Syllabus',
                                        style: GoogleFonts.oswald(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Browse folders and open uploaded study PDFs',
                                        style: GoogleFonts.nunito(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatChip(
                                    label: 'Folders',
                                    value: folders.length.toString(),
                                    accent: const Color(0xFF8EC5FF),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatChip(
                                    label: 'Files',
                                    value: totalFiles.toString(),
                                    accent: const Color(0xFF9DF0D6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (folders.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE6ECF5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B3D54).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.folder_open_outlined,
                                  color: Color(0xFF2B3D54),
                                  size: 34,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'No folders available yet',
                                style: GoogleFonts.oswald(
                                  fontSize: 20,
                                  color: const Color(0xFF111827),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Uploaded PDFs will appear here when admin adds them.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildFolderCard(folders[index], index),
                          childCount: folders.length,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _StatChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.oswald(
              color: accent,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
