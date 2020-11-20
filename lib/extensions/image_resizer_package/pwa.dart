import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:image_resizer/image_resizer.dart';
import '../hex_color.dart';
import 'text_based_config_files/pwa_config_files.dart';

class PwaConfigGenerator {
  PwaConfigGenerator(
      {@required this.color,
      this.indexExt = 'html',
      this.indexName = 'index',
      this.manifestName = 'manifest',
      this.manifestExt = 'json',
      this.path = 'web'});

  final Color color;
  final String indexExt, indexName, manifestName, manifestExt, path;

  String get _colorAsHex => '#${color.toHex(leadingHashSign: false).substring(2)}';

  List<FileData> generatePwaConfigs() {
    final List<FileData> pwaConfigs = [];
    final FileData indexHtmlFile = _generateIndexHtml();
    pwaConfigs.add(indexHtmlFile);
    final FileData manifestFile = _generateManifest();
    pwaConfigs.add(manifestFile);
    return pwaConfigs;
  }
  //TODO Add to-dos to configs, so users can easelly rename it.

  FileData _generateIndexHtml() {
    final List<int> indexHtmlFile = utf8.encode(pwaHtml(_colorAsHex));
    return FileData(indexHtmlFile, indexHtmlFile.length, '', '$path/$indexName.$indexExt');
  }

  FileData _generateManifest() {
    final List<int> manifestFile = utf8.encode(pwaManifest(_colorAsHex));
    return FileData(manifestFile, manifestFile.length, '', '$path/$manifestName.$manifestExt');
  }
}
