import 'package:image_resizer/image_resizer.dart';

const List<AndroidIcon> androidRegular = [
  AndroidIcon(size: 48, folderSuffix: 'mdpi', folder: _newFolderName),
  AndroidIcon(size: 72, folderSuffix: 'hdpi', folder: _newFolderName),
  AndroidIcon(size: 96, folderSuffix: 'xhdpi', folder: _newFolderName),
  AndroidIcon(size: 144, folderSuffix: 'xxhdpi', folder: _newFolderName),
  AndroidIcon(size: 192, folderSuffix: 'xxxhdpi', folder: _newFolderName),
];

const String _newFolderName = 'mipmap';
// const String _oldFolderName = 'hdpi';
