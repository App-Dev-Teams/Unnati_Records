import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  // Singleton pattern
  static final DownloadService _instance = DownloadService._internal();

  factory DownloadService() {
    return _instance;
  }

  DownloadService._internal();

  /// Get the local download directory path
  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadPath = '${directory.path}/Unnati_Downloads';

    // Create directory if it doesn't exist
    final dir = Directory(downloadPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return downloadPath;
  }

  /// Request storage permission
  Future<bool> requestStoragePermission() async {
    try {
      // For Android 13+ (API 33+) - Request MANAGE_EXTERNAL_STORAGE
      if (Platform.isAndroid) {
        final androidInfo = await _getAndroidVersion();
        
        if (androidInfo >= 33) {
          // Android 13+
          final status = await Permission.manageExternalStorage.request();
          
          if (status.isDenied) {
            print('Permission denied');
            return false;
          } else if (status.isPermanentlyDenied) {
            print('Permission permanently denied, opening app settings');
            openAppSettings();
            return false;
          }
          
          return status.isGranted;
        } else {
          // Android 12 and below
          final status = await Permission.storage.request();
          
          if (status.isDenied) {
            print('Permission denied');
            return false;
          } else if (status.isPermanentlyDenied) {
            print('Permission permanently denied, opening app settings');
            openAppSettings();
            return false;
          }
          
          return status.isGranted;
        }
      }
      
      // For iOS or other platforms
      return true;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }

  /// Get Android SDK version
  Future<int> _getAndroidVersion() async {
    try {
      if (Platform.isAndroid) {
        return 33;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Download file from URL and save to local storage
  /// Returns the local file path on success, null on failure
  Future<String?> downloadFile({
    required String fileUrl,
    required String fileName,
    Function(int received, int total)? onProgress,
  }) async {
    try {
      // Request permission
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Get local path
      final localPath = await getLocalPath();
      final filePath = '$localPath/$fileName';

      // Create file reference
      final file = File(filePath);

      // Download file with progress tracking
      final request = http.Request('GET', Uri.parse(fileUrl));
      final streamedResponse = await request.send().timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          throw Exception('Download timeout');
        },
      );

      if (streamedResponse.statusCode != 200) {
        throw Exception('Failed to download file: ${streamedResponse.statusCode}');
      }

      final contentLength = streamedResponse.contentLength ?? 0;
      int received = 0;

      // Create file and write bytes
      final sink = file.openWrite();

      await streamedResponse.stream.listen(
        (List<int> chunk) {
          received += chunk.length;
          sink.add(chunk);

          // Callback for progress
          if (onProgress != null) {
            onProgress(received, contentLength);
          }
        },
      ).asFuture();

      await sink.close();

      return filePath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  /// Check if file exists locally
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get file size in MB
  Future<String> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final sizeInBytes = await file.length();
        final sizeInMB = sizeInBytes / (1024 * 1024);
        return '${sizeInMB.toStringAsFixed(2)} MB';
      }
      return '0 MB';
    } catch (e) {
      return '0 MB';
    }
  }

  /// Delete a downloaded file
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  /// Get file extension from URL
  static String getFileExtension(String fileUrl) {
    try {
      final uri = Uri.parse(fileUrl);
      final path = uri.path;
      final lastDot = path.lastIndexOf('.');
      if (lastDot == -1) return '';
      return path.substring(lastDot);
    } catch (e) {
      return '';
    }
  }

  /// Generate unique filename to avoid conflicts
  static String generateUniqueFileName(String fileName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nameParts = fileName.split('.');
    if (nameParts.length > 1) {
      final extension = nameParts.last;
      final name = nameParts.sublist(0, nameParts.length - 1).join('.');
      return '${name}_$timestamp.$extension';
    }
    return '${fileName}_$timestamp';
  }

  /// Open a file (requires open_file package - not implemented here)
  /// You can use the open_file package from pubspec.yaml for this
  /// Example: await OpenFile.open(filePath);
}
