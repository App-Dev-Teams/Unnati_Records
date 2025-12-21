import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/features/volunteer_resources/volunteer_resource_model.dart';

class SubjectNotifier extends StateNotifier<List<Subject>> {
  SubjectNotifier() : super([]);

  void addSubject(String name, String className) {
    state = [...state, Subject(name: name, className: className)];
  }

  void addFile(String subjectName, String className, FileItem file) {
    state = state.map((subject) {
      if (subject.name == subjectName && subject.className == className) {
        return subject.copyWith(files: [...subject.files, file]);
      }
      return subject;
    }).toList();
  }

  // UPDATE SUBJECT NAME & CLASS
  void updateSubject({
    required String oldName,
    required String oldClass,
    required String newName,
    required String newClass,
  }) {
    state = state.map((subject) {
      if (subject.name == oldName && subject.className == oldClass) {
        return Subject(
          name: newName,
          className: newClass,
          files: subject.files, // files remain same
        );
      }
      return subject;
    }).toList();
  }

  // DELETE SUBJECT
  void deleteSubject(String name, String className) {
    state = state
        .where(
          (subject) =>
              !(subject.name == name && subject.className == className),
        )
        .toList();
  }

  //  EDIT FILE NAME
  void renameFile({
    required String subjectName,
    required String className,
    required FileItem oldFile,
    required String newName,
  }) {
    state = state.map((subject) {
      if (subject.name == subjectName && subject.className == className) {
        return subject.copyWith(
          files: subject.files.map((file) {
            if (file == oldFile) {
              return FileItem(
                name: newName,
                path: file.path,
                extension: file.extension,
              );
            }
            return file;
          }).toList(),
        );
      }
      return subject;
    }).toList();
  }

  // DELETE FILE
  void deleteFile(String subjectName, String className, FileItem fileToDelete) {
    state = state.map((subject) {
      if (subject.name == subjectName) {
        return subject.copyWith(
          files: subject.files.where((file) => file != fileToDelete).toList(),
        );
      }
      return subject;
    }).toList();
  }
}

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>(
  (ref) => SubjectNotifier(),
);
