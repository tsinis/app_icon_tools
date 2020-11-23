import 'package:image_resizer/image_resizer.dart';

const List<AndroidIcon> androidRegular = [
  AndroidIcon(size: 48, folderSuffix: 'mdpi', folder: _folder),
  AndroidIcon(size: 72, folderSuffix: 'hdpi', folder: _folder),
  AndroidIcon(size: 96, folderSuffix: 'xhdpi', folder: _folder),
  AndroidIcon(size: 144, folderSuffix: 'xxhdpi', folder: _folder),
  AndroidIcon(size: 192, folderSuffix: 'xxxhdpi', folder: _folder),
];

const String _folder = _newFolderName;
const String _newFolderName = 'mipmap';
// const String _oldFolderName = 'hdpi';
