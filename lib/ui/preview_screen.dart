import 'package:flutter/widgets.dart';

Image imagePreview;

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        child: imagePreview,
      );
}
