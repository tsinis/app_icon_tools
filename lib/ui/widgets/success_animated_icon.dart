import 'dart:math' as math show pi;
import 'package:flutter/material.dart';

class SuccessAnimatedIcon extends StatefulWidget {
  const SuccessAnimatedIcon({this.color = Colors.greenAccent, this.size = 150});
  final Color color;
  final double size;

  @override
  _SuccessAnimatedIcon createState() => _SuccessAnimatedIcon();
}

class _SuccessAnimatedIcon extends State<SuccessAnimatedIcon> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0.3, end: 1)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOutCirc));
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ShaderMask(
      shaderCallback: (bounds) => SweepGradient(
              center: const Alignment(0.5, 0.1),
              startAngle: math.pi / (3 * animation.value),
              endAngle: math.pi / (2.4 * animation.value),
              transform: const GradientRotation(math.pi / -2),
              colors: [Colors.transparent, widget.color],
              tileMode: TileMode.clamp)
          .createShader(bounds),
      child: ScaleTransition(scale: animation, child: Icon(Icons.check, size: widget.size, color: widget.color)));
}
