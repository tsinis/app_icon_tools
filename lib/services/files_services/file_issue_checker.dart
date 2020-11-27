import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import '../../constants/files_properties.dart';
import '../../constants/issues_levels.dart';

Map<String, bool> checkedIssues({@required Uint8List fileToCheck, @required bool isAdaptive}) {
  final bool tooHeavy = fileToCheck.buffer.lengthInBytes / 1000 > FilesProperties.maxFileSizeKB;
  final Image imageFile = decodePng(fileToCheck);
  final bool notSquare = imageFile.width != imageFile.height;
  final bool tooSmall =
      (imageFile.width < (isAdaptive ? FilesProperties.minAdaptiveSize : FilesProperties.minIconSize)) ||
          (imageFile.height < (isAdaptive ? FilesProperties.minAdaptiveSize : FilesProperties.minIconSize));
  final bool isTransparent = imageFile.channels == Channels.rgba;
  return {
    IssueLevel.alert: tooSmall,
    IssueLevel.danger: tooHeavy,
    IssueLevel.warning: notSquare,
    IssueLevel.info: isTransparent
  };
}
