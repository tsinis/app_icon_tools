import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'platforms_docs_urls.dart';
import 'platforms_names.dart';

class PlatformIcon {
  const PlatformIcon(this._id, this._name, this._icon, {double cornerRadius = 0, String docs = ''})
      : _docs = docs,
        _cornerRadius = cornerRadius;

  const PlatformIcon.androidOld()
      : _cornerRadius = 0,
        _id = 0,
        _name = PlatformName.androidOld,
        _icon = Icons.android_outlined,
        _docs = PlatformDocs.androidOld;

  const PlatformIcon.androidNew()
      : _cornerRadius = 800,
        _id = 1,
        _name = PlatformName.androidNew,
        _icon = CommunityMaterialIcons.android,
        _docs = PlatformDocs.androidNew;

  const PlatformIcon.iOS()
      : _cornerRadius = 53,
        _id = 2,
        _name = PlatformName.iOS,
        _icon = CommunityMaterialIcons.apple_ios,
        _docs = PlatformDocs.iOS;

  const PlatformIcon.pwa()
      : _cornerRadius = 800,
        _id = 3,
        _name = PlatformName.pwa,
        _icon = CommunityMaterialIcons.google_chrome,
        _docs = PlatformDocs.pwa;

  const PlatformIcon.windows()
      : _cornerRadius = 0,
        _id = 4,
        _name = PlatformName.windows,
        _icon = CommunityMaterialIcons.microsoft_windows,
        _docs = PlatformDocs.windows;

  const PlatformIcon.macOS()
      : _cornerRadius = 0,
        _id = 5,
        _name = PlatformName.macOS,
        _icon = CommunityMaterialIcons.apple,
        _docs = PlatformDocs.macOS;

  const PlatformIcon.linux()
      : _cornerRadius = 0,
        _id = 6,
        _name = PlatformName.linux,
        _icon = CommunityMaterialIcons.linux,
        _docs = PlatformDocs.linux;

  const PlatformIcon.fuchsiaOS()
      : _cornerRadius = 0,
        _id = 7,
        _name = PlatformName.fuchsia,
        _icon = CommunityMaterialIcons.circle,
        _docs = PlatformDocs.fuchsia;

  final double _cornerRadius;
  final IconData _icon;
  final String _name, _docs;
  final int _id;

  double get cornerRadius => _cornerRadius;
  IconData get icon => _icon;
  String get name => _name;
  String get docs => _docs;
  int get platformID => _id;

  bool get isAdaptive => _name == PlatformName.androidNew;

  bool get supportTransparency => _name != PlatformName.iOS;

  bool get canChangeShape =>
      _name == PlatformName.androidNew || _name == PlatformName.androidOld || _name == PlatformName.pwa;
}
