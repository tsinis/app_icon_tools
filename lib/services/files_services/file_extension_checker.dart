import '../../constants/files_properties.dart';

bool properExtension(String fileName) {
  if (fileName.length >= 4) {
    return fileName.substring(fileName.length - 4).toLowerCase() == '.${FilesProperties.expectedFileExtension}';
  } else {
    return false;
  }
}
