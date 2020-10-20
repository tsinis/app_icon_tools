// ignore: avoid_positional_boolean_parameters
String iconsXml(bool _asColor) {
  final String _type = _asColor ? 'color' : 'drawable';
  return '''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@$_type/ic_launcher_background"/>
  <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
''';
}

String colorsXml(String _color) => '''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">$_color</color>
</resources>
''';
