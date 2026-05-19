import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:unnati_app/features/volunteer_resources/volunteer_resource_model.dart';
import 'package:unnati_app/services/api_service.dart';

class SubjectNotifier extends StateNotifier<List<Subject>> {
  SubjectNotifier() : super([]);

  // void addSubject(String name, String className) {
  //   state = [...state, Subject(name: name, className: className)];
  // }

  // void addSubjectFromBackend(Subject subject) {
  //   state = [...state, subject];
  // }

  // void setSubjects(List<Subject> subjects) {
  //   state = subjects;
  // }

//load folders(subjects)
  Future<void> loadSubjects() async {
    try {
      final folders = await ApiService.fetchFolders();

      state = folders.map((folder) {
        return Subject(
          id: folder['_id'],
          name: folder['name'],
          className: folder['className'],
        );
      }).toList();
    } catch (e) {
      print(e);
    }
  }

//add subject to backend
  Future<void> createSubject({
    required String name,
    required String className,
  }) async {
    final folder = await ApiService.createFolder(
      name: name,
      className: className,
    );

    state = [
      ...state,
      Subject(
        id: folder['_id'],
        name: folder['name'],
        className: folder['className'],
      ),
    ];
  }

  //update subject in backend
  Future<void> updateSubject({
    required String id,
    required String newName,
    required String newClass,
  }) async {
    print("Updating...");
    print(id);
    print(newName);
    print(newClass);
    final updatedFolder = await ApiService.updateFolder(
      id: id,
      name: newName,
      className: newClass,
    );
    state = [
      for (final subject in state)
        if (subject.id == id)
          Subject(
            id: subject.id,
            name: updatedFolder['name'],
            className: updatedFolder['className'],
          )
        else
          subject,
    ];
  }

  //delete subject from backend
  Future<void> deleteSubject(String folderId) async {
    await ApiService.deleteFolder(folderId);

    state = state.where((subject) => subject.id != folderId).toList();
  }


  //upload file--
  Future<void> uploadFile({
    required String subjectName,
    required String className,
    required PlatformFile pickedFile,
    required String customName,
  }) async {
    // Find current subject
    final subject = state.firstWhere(
      (s) => s.name == subjectName && s.className == className,
    );

    if (subject.id == null) {
      throw Exception('Folder id missing');
    }

    // ==========================
    // 1. GET IMAGEKIT AUTH
    // ==========================
    final auth = await ApiService.getImageKitAuth();

    // ==========================
    // 2. Upload to ImageKit
    // ==========================
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
    );

    request.fields['fileName'] = pickedFile.name;
    request.fields['token'] = auth['token'].toString();
    request.fields['signature'] = auth['signature'].toString();
    request.fields['expire'] = auth['expire'].toString();
    request.fields['publicKey'] = 'public_60qksZwRpQMzV2CigoPfMTFSwGo=';

    request.files.add(
      await http.MultipartFile.fromPath('file', pickedFile.path!),
    );

    final streamed = await request.send();

    final response = await http.Response.fromStream(streamed);

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('ImageKit upload failed: ${response.body}');
    }

    final uploadData = json.decode(response.body);

    final imageUrl = uploadData['url'];

    final imagekitFileId = uploadData['fileId'];

    // ==========================
    // 3. Save metadata in Mongo
    // ==========================
    final savedFile = await ApiService.createFile(
      originalName: pickedFile.name,
      displayName: customName.isEmpty ? pickedFile.name : customName,
      link: imageUrl,
      folderId: subject.id!,
      type: pickedFile.extension ?? '',
      imagekitFileId: imagekitFileId,
    );

    // ==========================
    // 4. Update Riverpod state
    // ==========================
    final fileItem = FileItem(
      id: savedFile['_id'],
      imagekitFileId: savedFile['imagekitFileId'],
      name: savedFile['displayName'],
      path: '',
      extension: savedFile['type'],
      url: savedFile['link'],
    );

    state = [
      for (final s in state)
        if (s.id == subject.id)
          s.copyWith(files: [...s.files, fileItem])
        else
          s,
    ];
  }

  //load files for a subject--
  Future<void> loadFiles(String folderId) async {
  final files = await ApiService.fetchFilesByFolder(folderId);

  final loadedFiles =
      files.map((f) {
        return FileItem(
          id: f['_id'],
          name: f['displayName'],
          extension: f['type'],
          path: '',
          url: f['link'],
          imagekitFileId: f['imagekitFileId'],
        );
      }).toList();

    state = [
      for (final s in state)
        if (s.id == folderId)
          s.copyWith(
            files: loadedFiles,
          )
        else
          s,
    ];
  }

//rename file--
  Future<void> renameFile({
    required String subjectName,
    required String className,
    required FileItem oldFile,
    required String newName,
  }) async {
    final updated = await ApiService.updateFile(
      id: oldFile.id!,
      displayName: newName,
    );

    state = [
      for (final subject in state)
        if (
          subject.name == subjectName &&
          subject.className == className
        )
          Subject(
            id: subject.id,
            name: subject.name,
            className: subject.className,
            files: [
              for (final file in subject.files)
                if (file.id == oldFile.id)
                  FileItem(
                    id: file.id,
                    imagekitFileId: file.imagekitFileId,
                    name: updated['displayName'],
                    extension: file.extension,
                    path: file.path,
                    url: file.url,
                  )
                else
                  file,
            ],
          )
        else
          subject,
    ];
  }


//delete file--
  Future<void> deleteFile({
    required String subjectName,
    required String className,
    required FileItem file,
  }) async {
    await ApiService.deleteFile(
      file.id!,
    );

    state = [
      for (final subject in state)
        if (
          subject.name == subjectName &&
          subject.className == className
        )
          Subject(
            id: subject.id,
            name: subject.name,
            className: subject.className,
            files: subject.files
                .where(
                  (f) => f.id != file.id,
                )
                .toList(),
          )
        else
          subject,
    ];
  }

}

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>(
  (ref) => SubjectNotifier(),
);
