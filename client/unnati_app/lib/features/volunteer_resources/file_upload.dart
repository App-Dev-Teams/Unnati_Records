import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:unnati_app/features/volunteer_resources/volunteer_resource_model.dart';
import 'package:unnati_app/features/volunteer_resources/subject_provider_volunteer.dart';

class FileUploadPage extends ConsumerWidget {
  final String subject;
  const FileUploadPage({super.key, required this.subject});

  //bottom sheet function
  void _showAddFileSheet(BuildContext context, WidgetRef ref) {
    final fileNameController = TextEditingController();
    PlatformFile? pickedFile;

    showModalBottomSheet(
      //bottom sheet
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 20,
                  ),
                  children: [
                    Text(
                      'Upload File',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    TextField(
                      //file name
                      controller: fileNameController,
                      decoration: const InputDecoration(
                        labelText: 'File Name',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    OutlinedButton.icon(
                      //pick file
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.any,
                        );

                        if (result != null) {
                          setState(() {
                            pickedFile = result.files.single;
                          });
                        }
                      },
                      icon: const Icon(Icons.attach_file),
                      label: Text(
                        pickedFile == null
                            ? 'Pick File'
                            : 'Picked: ${pickedFile!.name}',
                      ),
                    ),

                    SizedBox(height: 20.h),

                    ElevatedButton(
                      //add button
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 9, 12, 19),
                      ),
                      onPressed: pickedFile == null
                          ? null
                          : () async {
                              final name =
                                  fileNameController.text.trim().isEmpty
                                      ? pickedFile!.name
                                      : fileNameController.text.trim();

                              final directory =
                                  await getExternalStorageDirectory();
                              if (directory == null) return;

                              final newPath =
                                  '${directory.path}/${pickedFile!.name}';

                              final newFile =
                                  await File(pickedFile!.path!).copy(newPath);

                              final fileItem = FileItem(
                                name: name,
                                path: newFile.path,
                                extension:
                                    (pickedFile!.extension ?? '').toLowerCase(),
                              );

                              ref
                                  .read(subjectProvider.notifier)
                                  .addFile(subject, fileItem);

                              Navigator.pop(context);
                            },
                      child: Text(
                        'Add File',
                        style: GoogleFonts.oswald(color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // cards icon
  Widget _fileIcon(FileItem file) {
    if (file.extension == 'pdf') {
      return const Icon(
        Icons.picture_as_pdf,
        size: 44,
        color: Colors.redAccent,
      );
    } else if (['jpg', 'jpeg', 'png'].contains(file.extension)) {
      return const Icon(Icons.image, size: 44, color: Colors.green);
    } else {
      return const Icon(
        Icons.insert_drive_file,
        size: 44,
        color: Colors.blueAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);
    final currentSubject = subjects.firstWhere((s) => s.name == subject);
    final files = currentSubject.files;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: AppBar(
        //app bar
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        foregroundColor: Colors.white,
        title: Text(
          subject,
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        // + button
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddFileSheet(context, ref),
      ),

      body: files.isEmpty
          ? Center(
              child: Text(
                'No files uploaded yet\nTap + to upload',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            )
          : GridView.builder(
              //file cards
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final file = files[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    final result = await OpenFile.open(file.path);
                    if (result.type != ResultType.done) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    }
                  },
                  child: Container(
                  
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      
                      gradient: const LinearGradient(
                        colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                      ),
                    ),
                    padding: const EdgeInsets.all(2), //border thickness
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white, //white card
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _fileIcon(file),

                          Flexible(
                            child: Text(
                              file.name,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //EDIT
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                                onPressed: () {
                                  final controller = TextEditingController(
                                    text: file.name,
                                  );

                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Edit File'),
                                      content: TextField(
                                        controller: controller,
                                        decoration:
                                            const InputDecoration(
                                          labelText: 'File Name',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            final newName =
                                                controller.text.trim();
                                            if (newName.isNotEmpty) {
                                              ref
                                                  .read(
                                                    subjectProvider.notifier,
                                                  )
                                                  .renameFile(
                                                    subjectName: subject,
                                                    oldFile: file,
                                                    newName: newName,
                                                  );
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Save',style: TextStyle(color: Colors.green),),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              //DELETE
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title:
                                          const Text('Delete File'),
                                      content: Text(
                                        'Are you sure you want to delete "${file.name}"?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child:  Text('Cancel',style: TextStyle(color: Colors.black),),
                                        ),
                                        ElevatedButton(
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(
                                                  subjectProvider.notifier,
                                                )
                                                .deleteFile(
                                                    subject, file);
                                            Navigator.pop(context);
                                          },
                                          child:
                                              const Text('Delete',style: TextStyle(color: Colors.white),),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
