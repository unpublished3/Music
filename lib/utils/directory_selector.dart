import 'package:file_picker/file_picker.dart';

Future<String> selectDirectory() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    return selectedDirectory;
  }

  return "@!!cancelled!!@";
}
