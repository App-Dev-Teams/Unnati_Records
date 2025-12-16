//model for subjects and file

class FileItem {
  final String name;
  final String path;
  final String extension;

  FileItem({
    required this.name,
    required this.path,
    required this.extension,
  });
}

class Subject {
  final String name;
  final String className;
  final List<FileItem> files;

  Subject({
    required this.name,
    required this.className,
    this.files = const [],
  });

  Subject copyWith({
    List<FileItem>? files,
  }) {
    return Subject(
      name: name,
      className: className,
      files: files ?? this.files,
    );
  }
}
