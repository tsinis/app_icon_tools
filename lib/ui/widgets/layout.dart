import 'package:flutter/widgets.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout({Key key, this.children, this.portraitOrientation}) : super(key: key);

  final List<Widget> children;
  final bool portraitOrientation;

  @override
  Widget build(BuildContext context) => portraitOrientation
      ? FractionallySizedBox(
          widthFactor: 0.9,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [const SizedBox(height: 20), ...children]),
          ),
        )
      : FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.9,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children),
        );
}
