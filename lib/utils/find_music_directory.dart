import 'dart:io';

// Specify the internal storage directory path
Future<List<FileSystemEntity>> findMp3Files() async {
// Specify the internal storage directory path
  Directory internalDir =
      Directory('/storage/emulated/0/Download'); // Change the path as needed

// List all files in the directory (recursive search)
  List files = 
      await internalDir.list(recursive: true, followLinks: false).toList();

// Filter MP3 files
  List<FileSystemEntity> mp3Files = [];
  for (FileSystemEntity entity in files) {
    String path = entity.path;
    if (path.endsWith('.mp3')) {
      mp3Files.add(entity);
    }
  }

// Now you have a list of MP3 files in internal storage
  return mp3Files;
}
