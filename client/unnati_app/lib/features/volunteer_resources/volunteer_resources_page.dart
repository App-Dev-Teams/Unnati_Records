import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/volunteer_resources/file_upload.dart';
import 'package:unnati_app/features/volunteer_resources/subject_provider_volunteer.dart';
import 'package:unnati_app/features/volunteer_resources/volunteer_resource_model.dart';
import 'package:unnati_app/services/api_service.dart';

class VolunteerResourcesPage extends ConsumerWidget {
  const VolunteerResourcesPage({super.key});

  void _showAddSubjectSheet(BuildContext context, WidgetRef ref) {
    final subjectController = TextEditingController();
    String? selectedClass;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Subject',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  //subject name
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: selectedClass,
                    decoration: const InputDecoration(
                      labelText: 'Class',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '6', child: Text('Class 6')),
                      DropdownMenuItem(value: '7', child: Text('Class 7')),
                      DropdownMenuItem(value: '8', child: Text('Class 8')),
                      DropdownMenuItem(value: '9', child: Text('Class 9')),
                      DropdownMenuItem(value: '10', child: Text('Class 10')),
                      DropdownMenuItem(value: '11', child: Text('Class 11')),
                      DropdownMenuItem(value: '12', child: Text('Class 12')),
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Classes'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedClass = value);
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 9, 12, 19),
                    ),
                    onPressed: () async {
                      final subject = subjectController.text.trim();
                      final cls = selectedClass;

                      if (subject.isEmpty || cls == null) return;

                      final subjects = ref.read(subjectProvider);

                      final alreadyExists = subjects.any(
                        (s) =>
                            s.name.toLowerCase() == subject.toLowerCase() &&
                            s.className == cls,
                      );

                      if (alreadyExists) {
                        Navigator.pop(modalContext);

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Subject with same class already exists',
                              ),
                            ),
                          );

                        return;
                      }

                      try {
                        final folder = await ApiService.createFolder(
                          name: subject,
                          className: cls,
                        );

                        ref.read(subjectProvider.notifier).addSubjectFromBackend(
                              Subject(
                                id: folder['_id'] as String,
                                name: folder['name'] as String,
                                className:
                                    (folder['className'] ?? '') as String,
                              ),
                            );

                        Navigator.pop(modalContext);
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Failed to create subject: $e',
                              ),
                            ),
                          );
                      }
                    },

                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider); //watch changes

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Resources',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 9, 12, 19),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubjectSheet(context, ref),
        backgroundColor: Color.fromARGB(255, 9, 12, 19),
        child: Icon(Icons.add, color: Colors.white),
      ),

      body: subjects.isEmpty
          ? Center(
              child: Text(
                'No subjects added yet',
                style: GoogleFonts.roboto(color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: subjects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //2 cards in one row
                crossAxisSpacing: 12.w, //horizontal gap
                mainAxisSpacing: 12.h, //vertical gap
                childAspectRatio: 0.95, //card height/width ratio
              ),
              itemBuilder: (context, index) {
                final subject = subjects[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FileUploadPage(
                          subject: subject.name,
                          className: subject.className,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    //cards
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 6.r),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.menu_book_sharp,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            subject.name, //subject name
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            //class
                            'Class ${subject.className}',
                            style: GoogleFonts.roboto(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),
                          // SizedBox(height: 12.h), // spacing instead of Spacer
                          Align(
                            //icon
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //edit
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white70,
                                    size: 18.sp,
                                  ),
                                  onPressed: () {
                                    final subjectController =
                                        TextEditingController(
                                          text: subject.name,
                                        );
                                    String selectedClass = subject.className;

                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Edit Subject'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: subjectController,
                                              decoration: const InputDecoration(
                                                labelText: 'Subject Name',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              initialValue: selectedClass,
                                              decoration: const InputDecoration(
                                                labelText: 'Class',
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: '6',
                                                  child: Text('Class 6'),
                                                ),
                                                DropdownMenuItem(
                                                  value: '7',
                                                  child: Text('Class 7'),
                                                ),
                                                DropdownMenuItem(
                                                  value: '8',
                                                  child: Text('Class 8'),
                                                ),
                                                DropdownMenuItem(
                                                  value: '9',
                                                  child: Text('Class 9'),
                                                ),
                                                DropdownMenuItem(
                                                  value: '10',
                                                  child: Text('Class 10'),
                                                ),
                                                DropdownMenuItem(
                                                  value: '11',
                                                  child: Text('Class 11'),
                                                ),
                                                DropdownMenuItem(
                                                  value: '12',
                                                  child: Text('Class 12'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'all',
                                                  child: Text('All classes'),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  selectedClass = value;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final newName = subjectController
                                                  .text
                                                  .trim();
                                              final newClass = selectedClass;

                                              if (newName.isEmpty ||
                                                  newClass.isEmpty) {
                                                return;
                                              }

                                              final subjects = ref.read(
                                                subjectProvider,
                                              );

                                              final alreadyExists = subjects.any(
                                                (s) =>
                                                    s.name.toLowerCase() ==
                                                        newName.toLowerCase() &&
                                                    s.className == newClass &&
                                                    !(s.name == subject.name &&
                                                        s.className ==
                                                            subject
                                                                .className), // exclude self
                                              );

                                              if (alreadyExists) {
                                                ScaffoldMessenger.of(
                                                    Navigator.of(
                                                      context,
                                                    ).context, // root context
                                                  )
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(
                                                    const SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content: Text(
                                                        'Subject with same class already exists',
                                                      ),
                                                    ),
                                                  );
                                                Navigator.pop(context);
                                                return; // ❌ TERMINATE EDIT
                                              }

                                              ref
                                                  .read(
                                                    subjectProvider.notifier,
                                                  )
                                                  .updateSubject(
                                                    oldName: subject.name,
                                                    oldClass: subject.className,
                                                    newName: newName,
                                                    newClass: newClass,
                                                  );

                                              Navigator.pop(
                                                context,
                                              ); // ✅ close dialog only on success
                                            },

                                            child: const Text(
                                              'Save',
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                //DELETE
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 18.sp,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Delete Subject'),
                                        content: Text(
                                          'Are you sure you want to delete "${subject.name}"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                    subjectProvider.notifier,
                                                  )
                                                  .deleteSubject(
                                                    subject.name,
                                                    subject.className,
                                                  );
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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
