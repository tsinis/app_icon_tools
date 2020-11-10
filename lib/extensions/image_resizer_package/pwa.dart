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
    final List<FileData> _pwaConfigs = [];
    final FileData _indexHtmlFile = _generateIndexHtml();
    _pwaConfigs.add(_indexHtmlFile);
    final FileData _manifestFile = _generateManifest();
    _pwaConfigs.add(_manifestFile);
    return _pwaConfigs;
  }

  FileData _generateIndexHtml() {
    final List<int> _indexHtmlFile = utf8.encode(pwaHtml(_colorAsHex));
    return FileData(_indexHtmlFile, _indexHtmlFile.length, '', '$path/$indexName.$indexExt');
  }

  FileData _generateManifest() {
    final List<int> _manifestFile = utf8.encode(pwaManifest(_colorAsHex));
    return FileData(_manifestFile, _manifestFile.length, '', '$path/$manifestName.$manifestExt');
  }
}
