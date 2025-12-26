// Model for subjects and files

class FileItem {
  final String? id;

  final String name;

  final String path;

  final String extension;

  final String? url;

  FileItem({
    this.id,
    required this.name,
    required this.path,
    required this.extension,
    this.url,
  });
}

class Subject {
  final String? id;

  final String name;
  final String className;
  final List<FileItem> files;

  Subject({
    this.id,
    required this.name,
    required this.className,
    this.files = const [],
  });

  Subject copyWith({
    String? id,
    String? name,
    String? className,
    List<FileItem>? files,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      className: className ?? this.className,
      files: files ?? this.files,
    );
  }
}
