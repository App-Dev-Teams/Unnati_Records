import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Download {
  final int? id;
  final String title;
  final String filePath;
  final String fileUrl;
  final String downloadedAt;
  final String fileSize;
  final String fileType; // 'pdf' or 'image'

  Download({
    this.id,
    required this.title,
    required this.filePath,
    required this.fileUrl,
    required this.downloadedAt,
    required this.fileSize,
    required this.fileType,
  });

  // Convert Download object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'fileUrl': fileUrl,
      'downloadedAt': downloadedAt,
      'fileSize': fileSize,
      'fileType': fileType,
    };
  }

  // Convert Map from database to Download object
  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
      id: map['id'] as int?,
      title: map['title'] as String,
      filePath: map['filePath'] as String,
      fileUrl: map['fileUrl'] as String,
      downloadedAt: map['downloadedAt'] as String,
      fileSize: map['fileSize'] as String,
      fileType: map['fileType'] as String,
    );
  }

  // Create a copy of Download with modified fields
  Download copyWith({
    int? id,
    String? title,
    String? filePath,
    String? fileUrl,
    String? downloadedAt,
    String? fileSize,
    String? fileType,
  }) {
    return Download(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
    );
  }

  @override
  String toString() {
    return 'Download(id: $id, title: $title, fileType: $fileType, fileSize: $fileSize)';
  }
}

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Get or initialize the database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'unnati_downloads.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Create database tables
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE downloads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        filePath TEXT NOT NULL,
        fileUrl TEXT NOT NULL,
        downloadedAt TEXT NOT NULL,
        fileSize TEXT NOT NULL,
        fileType TEXT NOT NULL
      )
    ''');
  }

  // Insert a new download record
  Future<int> insertDownload(Download download) async {
    try {
      final db = await database;
      final id = await db.insert(
        'downloads',
        download.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print('Error inserting download: $e');
      return -1;
    }
  }

  // Get all downloads
  Future<List<Download>> getAllDownloads() async {
    try {
      final db = await database;
      final maps = await db.query('downloads', orderBy: 'downloadedAt DESC');

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (i) => Download.fromMap(maps[i]),
      );
    } catch (e) {
      print('Error fetching downloads: $e');
      return [];
    }
  }

  // Get download by ID
  Future<Download?> getDownloadById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'downloads',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Download.fromMap(maps.first);
    } catch (e) {
      print('Error fetching download by id: $e');
      return null;
    }
  }

  // Check if a download exists by title and URL
  Future<bool> downloadExists(String title, String fileUrl) async {
    try {
      final db = await database;
      final maps = await db.query(
        'downloads',
        where: 'title = ? AND fileUrl = ?',
        whereArgs: [title, fileUrl],
      );

      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking download existence: $e');
      return false;
    }
  }

  // Check if a file path is already downloaded
  Future<Download?> getDownloadByFilePath(String filePath) async {
    try {
      final db = await database;
      final maps = await db.query(
        'downloads',
        where: 'filePath = ?',
        whereArgs: [filePath],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Download.fromMap(maps.first);
    } catch (e) {
      print('Error fetching download by path: $e');
      return null;
    }
  }

  // Get downloads by file type
  Future<List<Download>> getDownloadsByType(String fileType) async {
    try {
      final db = await database;
      final maps = await db.query(
        'downloads',
        where: 'fileType = ?',
        whereArgs: [fileType],
        orderBy: 'downloadedAt DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (i) => Download.fromMap(maps[i]),
      );
    } catch (e) {
      print('Error fetching downloads by type: $e');
      return [];
    }
  }

  // Update a download record
  Future<int> updateDownload(Download download) async {
    try {
      final db = await database;
      return await db.update(
        'downloads',
        download.toMap(),
        where: 'id = ?',
        whereArgs: [download.id],
      );
    } catch (e) {
      print('Error updating download: $e');
      return -1;
    }
  }

  // Delete a download record
  Future<int> deleteDownload(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'downloads',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting download: $e');
      return -1;
    }
  }

  // Delete all downloads
  Future<int> deleteAllDownloads() async {
    try {
      final db = await database;
      return await db.delete('downloads');
    } catch (e) {
      print('Error deleting all downloads: $e');
      return -1;
    }
  }

  // Get total number of downloads
  Future<int> getTotalDownloadsCount() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM downloads');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error getting downloads count: $e');
      return 0;
    }
  }

  // Search downloads by title
  Future<List<Download>> searchDownloads(String query) async {
    try {
      final db = await database;
      final maps = await db.query(
        'downloads',
        where: 'title LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'downloadedAt DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (i) => Download.fromMap(maps[i]),
      );
    } catch (e) {
      print('Error searching downloads: $e');
      return [];
    }
  }

  // Close database connection
  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }

  // Delete database (for reset/debugging)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'unnati_downloads.db');
    await deleteDatabase();
  }
}
