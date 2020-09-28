import 'package:flutter/material.dart';

import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

// class IconWithShape extends StatelessWidget {
//   const IconWithShape({@required bool supportTransparency, int cornerRadius, bool adaptiveIcon = false, Key key})
//       : _supportTransparency = supportTransparency,
//         _cornerRadius = cornerRadius,
//         _adaptiveIcon = adaptiveIcon,
//         super(key: key);

//   final bool _supportTransparency, _adaptiveIcon;
//   final int _cornerRadius;

//   bool get _onDevice => _cornerRadius != null;

//   @override
//   Widget build(BuildContext context) {
//     final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
//     final Image _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
//     final bool _colorNotSet = _backgroundColor == null;
//     final bool _haveAdaptiveBackground = _backgroundImage != null;
//     return ClipRRect(
//       borderRadius: BorderRadius.all(Radius.circular(_onDevice ? _cornerRadius / 8 ?? 0 : 0)),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           if (!_onDevice) const TransparencyGrid(),
//           if (_haveAdaptiveBackground && _adaptiveIcon)
//             ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(_onDevice ? 40 : 0)),
//                 child: Transform.scale(scale: 1.42, child: _backgroundImage)),
//           Container(
//             clipBehavior: Clip.hardEdge,
//             decoration: BoxDecoration(
//                 color: _colorNotSet
//                     ? _supportTransparency
//                         ? Colors.transparent
//                         : Colors.black
//                     : _adaptiveIcon && _haveAdaptiveBackground
//                         ? Colors.transparent
//                         : _backgroundColor),
//             child: LocalHero(tag: 'local', child: context.watch<SetupIcon>().icon),
//           )
//         ],
//       ),
//     );
//   }
// }

class IconWithShape extends StatefulWidget {
  const IconWithShape({@required bool supportTransparency, int cornerRadius, bool adaptiveIcon = false, Key key})
      : _supportTransparency = supportTransparency,
        _cornerRadius = cornerRadius,
        _adaptiveIcon = adaptiveIcon,
        super(key: key);

  final bool _supportTransparency, _adaptiveIcon;
  final int _cornerRadius;
  bool get _onDevice => _cornerRadius != null;

  @override
  _IconWithShapeState createState() => _IconWithShapeState();
}

AnimationController _controller;

Future<Null> playAnimation() async {
  try {
    await _controller.forward().orCancel;
    await _controller.reverse().orCancel;
    // ignore: empty_catches
  } on TickerCanceled {}
}

class _IconWithShapeState extends State<IconWithShape> with SingleTickerProviderStateMixin {
  bool _haveAdaptiveBackground, _colorNotSet;
  Color _backgroundColor;
  Image _backgroundImage;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.4)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    _colorNotSet = _backgroundColor == null;
    _haveAdaptiveBackground = _backgroundImage != null;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!widget._onDevice || !_haveAdaptiveBackground) const TransparencyGrid(),
        if (_haveAdaptiveBackground && widget._adaptiveIcon)
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(widget._onDevice ? 40 : 0)),
              child: Transform.scale(scale: 1.42, child: _backgroundImage)),
        Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: _colorNotSet
                    ? widget._supportTransparency
                        ? Colors.transparent
                        : Colors.black
                    : widget._adaptiveIcon && _haveAdaptiveBackground
                        ? Colors.transparent
                        : _backgroundColor)),
        LocalHero(
          tag: 'local',
          child: SlideTransition(position: _animation, child: context.watch<SetupIcon>().icon),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget._onDevice ? widget._cornerRadius / 8 ?? 0 : 0)),
      child: AnimatedBuilder(animation: _controller, builder: _buildAnimation));
}
