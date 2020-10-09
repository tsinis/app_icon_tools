import 'package:flutter/material.dart';

import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

class AdaptiveIcon extends StatefulWidget {
  const AdaptiveIcon({Key key, this.onDevice = false}) : super(key: key);
  final bool onDevice;
  @override
  _AdaptiveIconState createState() => _AdaptiveIconState();

  static Future<void> preview(String _direction) async {
    const double _offset = 0.1;
    Offset _end;
    switch (_direction) {
      case 'down':
        _end = const Offset(0, _offset);
        break;
      case 'up':
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
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
      // ignore: empty_catches
    } on TickerCanceled {}
  }
}

AnimationController _controller;
Animation<Offset> _animation;

class _AdaptiveIconState extends State<AdaptiveIcon> with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    final bool _previewMode = context.read<SetupIcon>().devicePreview;
    if (!_previewMode) {
      //TODO Fix this!
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800), reverseDuration: const Duration(milliseconds: 1000));
    _animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.1)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final Image _background = context.select((SetupIcon icon) => icon.adaptiveBackground);
    final Image _foreground = context.select((SetupIcon icon) => icon.adaptiveForeground);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget _) => Stack(
        alignment: Alignment.center,
        children: [
          if (!widget.onDevice) const TransparencyGrid(),
          if (_background != null)
            FractionallySizedBox(
              widthFactor: 0.7,
              heightFactor: 0.7,
              child: SlideTransition(position: _animation, child: Transform.scale(scale: 2, child: _background)),
            ),
          LocalHero(
            tag: 'adaptive',
            child: SlideTransition(position: _animation, child: Transform.scale(scale: 1.42, child: _foreground)),
          ),
        ],
      ),
    );
  }
}
