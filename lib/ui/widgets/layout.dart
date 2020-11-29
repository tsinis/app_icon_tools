import 'dart:math' show min;

import 'package:flutter/widgets.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout({@required this.children, @required this.portraitOrientation, Key key}) : super(key: key);
  final List<Widget> children;
  final bool portraitOrientation;

  static const int _heightLimit = 730;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final bool needsScroll = height <= _heightLimit;

    return FractionallySizedBox(
      widthFactor: portraitOrientation ? 0.94 : 0.9,
      heightFactor:
          (portraitOrientation || needsScroll) ? 1 : min(1, 2 - (height / _heightLimit)).clamp(0.6, 1).toDouble(),
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
