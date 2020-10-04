import 'package:flutter/material.dart';

import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

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

  static Future<void> playAnimation(String _direction) async {
    const double _offset = 0.2;
    Offset _end;
    switch (_direction) {
      case 'down':
        _end = const Offset(0, _offset);
        break;
      case 'top':
        _end = const Offset(0, -_offset);
        break;
      case 'right':
        _end = const Offset(_offset, 0);
        break;
      case 'left':
        _end = const Offset(-_offset, 0);
        break;
    }
    _animation = Tween<Offset>(begin: Offset.zero, end: _end)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn, reverseCurve: Curves.elasticOut));
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
      // ignore: empty_catches
    } on TickerCanceled {}
  }
}

AnimationController _controller;
Animation<Offset> _animation;

class _IconWithShapeState extends State<IconWithShape> with SingleTickerProviderStateMixin {
  bool _haveAdaptiveBackground, _colorNotSet;
  Color _backgroundColor;
  Image _backgroundImage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 300));
    _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.4)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _disposed = true;
  }

  @override
  Widget build(BuildContext context) {
    _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    _colorNotSet = _backgroundColor == null;
    _haveAdaptiveBackground = _backgroundImage != null;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget._onDevice ? widget._cornerRadius / 8 ?? 0 : 0)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (!widget._onDevice) const TransparencyGrid(),
              if (_haveAdaptiveBackground && widget._adaptiveIcon)
                widget._onDevice
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                        child: Transform.scale(scale: 1.42, child: _backgroundImage))
                    : FractionallySizedBox(
                        widthFactor: 0.7,
                        heightFactor: 0.7,
                        child: SlideTransition(
                            position: _animation, child: Transform.scale(scale: 1.42, child: _backgroundImage)),
                      ),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: _colorNotSet
                        ? widget._supportTransparency
                            ? Colors.transparent
                            : Colors.black
                        : widget._adaptiveIcon && _haveAdaptiveBackground
                            ? Colors.transparent
                            : _backgroundColor),
                child: LocalHero(
                  tag: 'local',
                  child: SlideTransition(
                      position: _animation,
                      child: Transform.scale(
                          scale: (widget._adaptiveIcon && !widget._onDevice) ? 1.42 : 1,
                          child: context.watch<SetupIcon>().icon)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
