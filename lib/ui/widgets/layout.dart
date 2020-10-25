import 'package:flutter/widgets.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout({Key key, this.children, this.portraitOrientation}) : super(key: key);

  final List<Widget> children;
  final bool portraitOrientation;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: portraitOrientation ? 1 : 0.9,
        child: SingleChildScrollView(
          child: portraitOrientation
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [const SizedBox(height: 20), ...children])
              : Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: children),
        ),
      );
}
