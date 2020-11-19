import 'dart:math' as math show pi;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/upload_file.dart';

class SuccessAnimatedIcon extends StatefulWidget {
  const SuccessAnimatedIcon({this.color = Colors.greenAccent, this.size = 80});
  final Color color;
  final double size;

  @override
  _SuccessAnimatedIcon createState() => _SuccessAnimatedIcon();
}

class _SuccessAnimatedIcon extends State<SuccessAnimatedIcon> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> angleAnimation, scaleAnimation;
  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    scaleAnimation =
        Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(parent: animationController, curve: Curves.slowMiddle));
    angleAnimation = Tween<double>(begin: 0.01, end: 1)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    // animationController.repeat();
    animationController.forward().whenComplete(() => context.read<UploadFile>().navigateToSetup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => kIsWeb
      ? ScaleTransition(scale: scaleAnimation, child: Icon(Icons.check, size: widget.size, color: widget.color))
      : ShaderMask(
          shaderCallback: (bounds) => SweepGradient(
                  center: const Alignment(0.5, 0.1),
                  startAngle: math.pi / (3 * angleAnimation.value),
                  endAngle: math.pi / (2.6 * angleAnimation.value),
                  transform: const GradientRotation(math.pi / -2),
                  colors: [widget.color.withOpacity(0), widget.color],
                  tileMode: TileMode.clamp)
              .createShader(bounds),
          child:
              ScaleTransition(scale: scaleAnimation, child: Icon(Icons.check, size: widget.size, color: widget.color)));
}
