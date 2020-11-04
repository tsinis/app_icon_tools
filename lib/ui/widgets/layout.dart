import 'package:flutter/widgets.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout(
      {@required this.children, @required this.portraitOrientation, @required this.needsScroll, Key key})
      : super(key: key);

  final List<Widget> children;
  final bool portraitOrientation, needsScroll;
  //TODO Add links to download. assets and articles.
  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: portraitOrientation ? 0.94 : 0.9,
        heightFactor: (portraitOrientation || needsScroll) ? 1 : 0.9,
        child: _ScrollChild(
          scroll: needsScroll || portraitOrientation,
          child: portraitOrientation
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [const SizedBox(height: 20), ...children])
              : Row(
                  textBaseline: TextBaseline.ideographic,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: children),
        ),
      );
}

class _ScrollChild extends StatelessWidget {
  final bool scroll;
  final Widget child;
  const _ScrollChild({@required this.scroll, @required this.child, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => scroll ? SingleChildScrollView(child: child) : SizedBox(child: child);
}
