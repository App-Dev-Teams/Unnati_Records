import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/volunteer_resources/file_upload.dart';
import 'package:unnati_app/features/volunteer_resources/subject_provider_volunteer.dart';

class VolunteerResourcesPage extends ConsumerWidget {
  const VolunteerResourcesPage({super.key});

  void _showAddSubjectSheet(BuildContext context, WidgetRef ref) {
    //bottom sheet function
    final subjectController = TextEditingController();
    final classController = TextEditingController();

    showModalBottomSheet(
      //bottom sheet
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Subject",
                  style: GoogleFonts.oswald(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: classController,
                  decoration: InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  //add button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 9, 12, 19),
                  ),
                  onPressed: () {
                    final subject = subjectController.text.trim();
                    final cls = classController.text.trim();
                    if (subject.isNotEmpty && cls.isNotEmpty) {
                      ref
                          .read(subjectProvider.notifier)
                          .addSubject(subject, cls);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider); //watch changes

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      //app bar
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
        //floating action button
        onPressed: () => _showAddSubjectSheet(context, ref),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 9, 12, 19),
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
                      //navigation
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FileUploadPage(subject: subject.name),
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
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.r,
                        ),
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
                                    final classController =
                                        TextEditingController(
                                          text: subject.className,
                                        );

                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            const Text('Edit Subject'),
                                        content: Column(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  subjectController,
                                              decoration:
                                                  const InputDecoration(
                                                labelText:
                                                    'Subject Name',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller:
                                                  classController,
                                              decoration:
                                                  const InputDecoration(
                                                labelText: 'Class',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child:
                                                const Text('Cancel',style: TextStyle(color: Colors.red),),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final newName =
                                                  subjectController
                                                      .text
                                                      .trim();
                                              final newClass =
                                                  classController
                                                      .text
                                                      .trim();

                                              if (newName.isNotEmpty &&
                                                  newClass.isNotEmpty) {
                                                ref
                                                    .read(
                                                      subjectProvider
                                                          .notifier,
                                                    )
                                                    .updateSubject(
                                                      oldName:
                                                          subject.name,
                                                      newName: newName,
                                                      newClass:
                                                          newClass,
                                                    );
                                              }
                                              Navigator.pop(context);
                                            },
                                            child:
                                                const Text('Save',style: TextStyle(color: Colors.green),),
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
                                        title: const Text(
                                            'Delete Subject'),
                                        content: Text(
                                          'Are you sure you want to delete "${subject.name}"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child:
                                                const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                                  Colors.red,
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                    subjectProvider
                                                        .notifier,
                                                  )
                                                  .deleteSubject(
                                                      subject.name);
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
