import 'package:flutter/widgets.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout({@required this.children, @required this.portraitOrientation, Key key}) : super(key: key);

  final List<Widget> children;
  final bool portraitOrientation;
  @override
  Widget build(BuildContext context) {
    final bool needsScroll = MediaQuery.of(context).size.height <= 760;

    return FractionallySizedBox(
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
}

class _ScrollChild extends StatelessWidget {
  const _ScrollChild({@required this.scroll, @required this.child, Key key}) : super(key: key);

  final Widget child;
  final bool scroll;

  @override
  Widget build(BuildContext context) => scroll ? SingleChildScrollView(child: child) : SizedBox(child: child);
}
