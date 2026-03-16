import 'dart:io';

/// Abstracts file system operations for testability and extensibility.
abstract class IFileSystem {
  Future<void> writeFile(String path, String content);
  Future<String> readFile(String path);
  Future<bool> fileExists(String path);
  Future<void> createDirectory(String path);
}

/// Default implementation using Dart's IO library.
class DefaultFileSystem implements IFileSystem {
  @override
  Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
  }

  @override
  Future<String> readFile(String path) async {
    final file = File(path);
    return await file.readAsString();
  }

  @override
  Future<bool> fileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }

  @override
  Future<void> createDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
}
