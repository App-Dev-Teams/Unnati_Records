class DownloadPdf {
  final String title;
  final String path;
  final String extension;

  DownloadPdf({
    required this.title,
    required this.path,
    this.extension = 'pdf',
  });

  factory DownloadPdf.fromJson(Map<String, dynamic> json) {
    return DownloadPdf(
      title: (json['title'] ?? '').toString(),
      path: (json['path'] ?? '').toString(),
      extension: (json['extension'] ?? 'pdf').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'path': path, 'extension': extension};
  }
}
