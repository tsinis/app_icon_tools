import '../../constants/icons_properties.dart';

bool properExtension(String fileName) {
  if (fileName.length >= 4) {
    return fileName.substring(fileName.length - 4).toLowerCase() == '.${IconsProperties.expectedFileExtension}';
  } else {
    return false;
  }
}
