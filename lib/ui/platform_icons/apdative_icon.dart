import 'package:flutter/material.dart';

import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

class AdaptiveIcon extends StatefulWidget {
  const AdaptiveIcon({Key key}) : super(key: key);

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

class _AdaptiveIconState extends State<AdaptiveIcon> with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 300));
    _animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.1)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final Image _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget _) => Stack(
        alignment: Alignment.center,
        children: [
          const TransparencyGrid(),
          if (_backgroundImage != null)
            FractionallySizedBox(
              widthFactor: 0.7,
              heightFactor: 0.7,
              child: SlideTransition(position: _animation, child: Transform.scale(scale: 2, child: _backgroundImage)),
            ),
          LocalHero(
            tag: 'local',
            child: SlideTransition(
                position: _animation, child: Transform.scale(scale: 1.42, child: context.watch<SetupIcon>().icon)),
          ),
        ],
      ),
    );
  }
}
