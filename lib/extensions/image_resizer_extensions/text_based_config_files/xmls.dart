// ignore: avoid_positional_boolean_parameters
String iconsXml(bool asColor) {
  final String type = asColor ? 'color' : 'drawable';
  return '''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@$type/ic_launcher_background"/>
  <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
''';
}

String colorsXml(String color) => '''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">$color</color>
</resources>
''';
