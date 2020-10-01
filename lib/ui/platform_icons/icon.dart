import 'package:animator/animator.dart';
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

  static final animatorKey = AnimatorKey<Offset>();
  final bool _supportTransparency, _adaptiveIcon;
  final int _cornerRadius;
  bool get _onDevice => _cornerRadius != null;

  @override
  _IconWithShapeState createState() => _IconWithShapeState();
}

class _IconWithShapeState extends State<IconWithShape> with SingleTickerProviderStateMixin {
  bool _haveAdaptiveBackground = false, _colorNotSet = true;
  Color _backgroundColor;
  Image _iconImage, _backgroundImage;

  Widget get _icon => Stack(
        alignment: Alignment.center,
        children: [
          if (!widget._onDevice) const TransparencyGrid(),
          if (_haveAdaptiveBackground && widget._adaptiveIcon)
            widget._onDevice
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: Transform.scale(scale: 1.42, child: _backgroundImage))
                : Transform.scale(scale: 1.42, child: _backgroundImage),
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
              child: widget._adaptiveIcon ? _iconImage : LocalHero(tag: 'local', child: _iconImage)),
        ],
      );

  String _animationSwitcher = 'left';

  void changeAnimation(String _switcher) => setState(() => _animationSwitcher = _switcher);

  @override
  Widget build(BuildContext context) {
    Widget _adaptive;
// TODO:! Fix this performance (Provider model called 4x during animation).
    _iconImage = context.select((SetupIcon icon) => icon.icon);
    _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    _colorNotSet = _backgroundColor == null;
    _haveAdaptiveBackground = _backgroundImage != null;

    switch (_animationSwitcher) {
      case 'left':
        _adaptive = Animator<Offset>(
            animatorKey: IconWithShape.animatorKey,
            key: const Key('left'),
            tween: Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-0.12, 0)),
            curve: Curves.elasticIn,
            duration: const Duration(milliseconds: 300),
            endAnimationListener: (_) {
              IconWithShape.animatorKey.refreshAnimation();
              changeAnimation('right');
            },
            builder: (_, animatorState, __) => SlideTransition(position: animatorState.animation, child: _icon));
        break;
      case 'right':
        _adaptive = Animator<Offset>(
            key: const Key('right'),
            tween: Tween<Offset>(begin: const Offset(-0.12, 0), end: const Offset(0.12, 0)),
            curve: Curves.easeInOutBack,
            endAnimationListener: (_) => changeAnimation('center'),
            builder: (_, animatorState, __) => SlideTransition(position: animatorState.animation, child: _icon));
        break;
      case 'center':
        _adaptive = Animator<Offset>(
            key: const Key('center'),
            tween: Tween<Offset>(begin: const Offset(0.12, 0), end: const Offset(0, 0)),
            curve: Curves.elasticOut,
            duration: const Duration(milliseconds: 800),
            endAnimationListener: (_) => changeAnimation('top'),
            builder: (_, animatorState, __) => SlideTransition(position: animatorState.animation, child: _icon));
        break;
      case 'top':
        _adaptive = Animator<Offset>(
            key: const Key('top'),
            tween: Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.12)),
            curve: Curves.elasticIn,
            duration: const Duration(milliseconds: 400),
            endAnimationListener: (_) => changeAnimation('bottom'),
            builder: (_, animatorState, __) => SlideTransition(position: animatorState.animation, child: _icon));
        break;
      case 'bottom':
        _adaptive = Animator<Offset>(
            key: const Key('bottom'),
            tween: Tween<Offset>(begin: const Offset(0, -0.12), end: const Offset(0, 0.12)),
            curve: Curves.easeInOutBack,
            endAnimationListener: (_) => changeAnimation('middle'),
            builder: (_, animatorState, __) => SlideTransition(position: animatorState.animation, child: _icon));
        break;
      case 'middle':
        _adaptive = Animator<Offset>(
            resetAnimationOnRebuild: true,
            key: const Key('middle'),
            tween: Tween<Offset>(begin: const Offset(0, 0.12), end: const Offset(0, 0)),
            curve: Curves.elasticOut,
            duration: const Duration(milliseconds: 800),
            endAnimationListener: (_) => changeAnimation('left'),
            builder: (_, animatorState, __) => SlideTransition(position: animatorState.animation, child: _icon));
        break;
      default:
        _adaptive = _icon;
    }
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget._onDevice ? widget._cornerRadius / 8 ?? 0 : 0)),
        child: widget._adaptiveIcon ? _adaptive : _icon);
  }
}
