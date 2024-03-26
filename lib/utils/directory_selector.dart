import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> selectDirectory() async {
  String? storedDirectory = await loadDirectory();
  if (storedDirectory != null) {
    return storedDirectory;
  }

  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    saveDirectory(selectedDirectory);
    return selectedDirectory;
  }

  return "@!!cancelled!!@";
}

Future<void> saveDirectory(String directory) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("selectedDirectory", directory);
}

Future<String?> loadDirectory() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("selectedDirectory");
}
