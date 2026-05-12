import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:unnati_admin/features/adminappbar.dart';
import 'package:unnati_admin/services/api_service.dart';

const String _imageKitPublicKey = 'public_60qksZwRpQMzV2CigoPfMTFSwGo=';

class AdminFileUploadPage extends StatefulWidget {
  const AdminFileUploadPage({super.key});

  @override
  State<AdminFileUploadPage> createState() => _AdminFileUploadPageState();
}

class _AdminFileUploadPageState extends State<AdminFileUploadPage> {
  List<Map<String, dynamic>> folders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await AdminApiService.fetchFolders();
      if (!mounted) return;
      setState(() {
        folders = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load folders: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showAddFolderSheet() {
    final subjectController = TextEditingController();
    String? selectedClass;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF111212),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Create Folder',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: subjectController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Subject Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 14, 22, 33),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedClass,
                    dropdownColor: const Color.fromARGB(255, 14, 22, 33),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Class',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 14, 22, 33),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: '6', child: Text('Class 6')),
                      DropdownMenuItem(value: '7', child: Text('Class 7')),
                      DropdownMenuItem(value: '8', child: Text('Class 8')),
                      DropdownMenuItem(value: '9', child: Text('Class 9')),
                      DropdownMenuItem(value: '10', child: Text('Class 10')),
                      DropdownMenuItem(value: '11', child: Text('Class 11')),
                      DropdownMenuItem(value: '12', child: Text('Class 12')),
                      DropdownMenuItem(value: 'all', child: Text('All Classes')),
                    ],
                    onChanged: (value) {
                      setModalState(() => selectedClass = value);
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final subject = subjectController.text.trim();
                        final cls = selectedClass;

                        if (subject.isEmpty || cls == null) {
                          return;
                        }

                        final alreadyExists = folders.any(
                          (f) =>
                              (f['name'] ?? '').toString().toLowerCase() ==
                                  subject.toLowerCase() &&
                              (f['className'] ?? '').toString() == cls,
                        );

                        if (alreadyExists) {
                          Navigator.pop(modalContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Folder with same class already exists'),
                            ),
                          );
                          return;
                        }

                        try {
                          final folder = await AdminApiService.createFolder(
                            name: subject,
                            className: cls,
                          );

                          if (!mounted) return;
                          setState(() {
                            folders = [folder, ...folders];
                          });
                          if (modalContext.mounted) {
                            Navigator.pop(modalContext);
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to create folder: $e')),
                          );
                        }
                      },
                      child: Text(
                        'Create',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      appBar: const AdminAppBar(
        name: 'Upload Files',
        imageName: 'unnatiLogoColourFix.png',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
        onPressed: _showAddFolderSheet,
        child: const Icon(Icons.create_new_folder, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Folder To Upload',
              style: GoogleFonts.oswald(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create folder first, then upload files inside it',
              style: GoogleFonts.nunito(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : folders.isEmpty
                      ? Center(
                          child: Text(
                            'No folders yet\nTap + to create one',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            final folderId = (folder['_id'] ?? '').toString();
                            final folderName =
                                (folder['name'] ?? 'Untitled').toString();
                            final className =
                                (folder['className'] ?? '').toString();

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdminFolderUploadPage(
                                      folderId: folderId,
                                      folderName: folderName,
                                      className: className,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color.fromARGB(255, 14, 22, 33),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.folder, color: Colors.amber),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            folderName,
                                            style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Class $className',
                                            style: GoogleFonts.nunito(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminFolderUploadPage extends StatefulWidget {
  final String folderId;
  final String folderName;
  final String className;

  const AdminFolderUploadPage({
    super.key,
    required this.folderId,
    required this.folderName,
    required this.className,
  });

  @override
  State<AdminFolderUploadPage> createState() => _AdminFolderUploadPageState();
}

class _AdminFolderUploadPageState extends State<AdminFolderUploadPage> {
  List<Map<String, String>> uploadedFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingFiles();
  }

  Future<void> _loadExistingFiles() async {
    setState(() {
      isLoading = true;
    });
    try {
      final files = await AdminApiService.fetchFilesByFolder(widget.folderId);
      if (!mounted) return;
      setState(() {
        uploadedFiles = files
            .map(
              (f) => {
                'name': (f['displayName'] ?? '').toString(),
                'type': (f['type'] ?? '').toString(),
              },
            )
            .toList();
      });
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showAddFileSheet(BuildContext scaffoldContext) {
    final fileNameController = TextEditingController();
    PlatformFile? pickedFile;

    showModalBottomSheet(
      context: scaffoldContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              height: MediaQuery.of(scaffoldContext).size.height * 0.6,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF111212),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Upload File',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: fileNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'File Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 14, 22, 33),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8EC5FF)),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 14, 22, 33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null && result.files.isNotEmpty) {
                          setModalState(() {
                            pickedFile = result.files.single;
                          });
                        } else if (scaffoldContext.mounted) {
                          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            const SnackBar(content: Text('No file selected')),
                          );
                        }
                      } catch (e) {
                        if (scaffoldContext.mounted) {
                          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            SnackBar(
                              content: Text('Unable to open file picker: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      pickedFile == null
                          ? 'Pick File'
                          : 'Picked: ${pickedFile!.name}',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: pickedFile == null
                          ? null
                          : () async {
                              final name =
                                  fileNameController.text.trim().isEmpty
                                      ? pickedFile!.name
                                      : fileNameController.text.trim();

                              if (pickedFile!.extension?.toLowerCase() != 'pdf') {
                                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('Only PDF files are allowed for upload.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              try {
                                final auth = await AdminApiService.getImageKitAuth();
                                final dynamic authPublicKey = auth['publicKey'];
                                final String publicKey = authPublicKey != null &&
                                        authPublicKey.toString().trim().isNotEmpty
                                    ? authPublicKey.toString().trim()
                                    : _imageKitPublicKey.trim();

                                if (publicKey.isEmpty) {
                                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'ImageKit public key missing in app configuration.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final uploadRequest = http.MultipartRequest(
                                  'POST',
                                  Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
                                )
                                  ..fields['fileName'] = pickedFile!.name
                                  ..fields['publicKey'] = publicKey
                                  ..fields['token'] = auth['token'].toString()
                                  ..fields['signature'] = auth['signature'].toString()
                                  ..fields['expire'] = auth['expire'].toString();

                                if (pickedFile!.path != null) {
                                  uploadRequest.files.add(
                                    await http.MultipartFile.fromPath(
                                      'file',
                                      pickedFile!.path!,
                                    ),
                                  );
                                } else {
                                  uploadRequest.files.add(
                                    http.MultipartFile.fromBytes(
                                      'file',
                                      pickedFile!.bytes!,
                                      filename: pickedFile!.name,
                                    ),
                                  );
                                }

                                final streamed = await uploadRequest.send();
                                final uploadResponse = await http.Response.fromStream(streamed);

                                if (uploadResponse.statusCode < 200 ||
                                    uploadResponse.statusCode >= 300) {
                                  throw Exception('ImageKit upload failed: ${uploadResponse.body}');
                                }

                                final uploadData = json.decode(uploadResponse.body)
                                    as Map<String, dynamic>;

                                final imageUrl = uploadData['url'] as String;
                                final imagekitFileId = uploadData['fileId'] as String;

                                final fileMeta = await AdminApiService.createFile(
                                  originalName: pickedFile!.name,
                                  displayName: name,
                                  link: imageUrl,
                                  folderId: widget.folderId,
                                  type: (pickedFile!.extension ?? '').toLowerCase(),
                                  imagekitFileId: imagekitFileId,
                                );

                                if (!mounted) return;
                                setState(() {
                                  uploadedFiles.insert(0, {
                                    'name': (fileMeta['displayName'] ?? name).toString(),
                                    'type': (fileMeta['type'] ?? '').toString(),
                                  });
                                });

                                if (modalContext.mounted) {
                                  Navigator.pop(modalContext);
                                }
                                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('File uploaded successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to upload file: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: Text(
                        'Add File',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      appBar: AdminAppBar(
        name: '${widget.folderName} (Class ${widget.className})',
        imageName: 'unnatiLogoColourFix.png',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
        onPressed: () => _showAddFileSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Files In ${widget.folderName}',
              style: GoogleFonts.oswald(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Class ${widget.className}',
              style: GoogleFonts.nunito(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : uploadedFiles.isEmpty
                      ? Center(
                          child: Text(
                            'No files uploaded yet\nTap + to upload',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: uploadedFiles.length,
                          itemBuilder: (context, index) {
                            final file = uploadedFiles[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(255, 14, 22, 33),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      file['name'] ?? '',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (file['type'] ?? '').toUpperCase(),
                                    style: GoogleFonts.nunito(color: Colors.white70),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
