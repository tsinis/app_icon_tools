import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/default_non_null_values.dart';
import '../../../models/setup_icon.dart';
import '../transparency_grid.dart';

class AdaptiveIcon extends StatefulWidget {
  const AdaptiveIcon({Key key, this.onDevice = false}) : super(key: key);

  static Animation<Offset> animation;
  static AnimationController controller;
  static const String moveDown = 'down', moveUp = 'up', moveRight = 'right', moveLeft = 'left';

  final bool onDevice;

  @override
  _AdaptiveIconState createState() => _AdaptiveIconState();

  static Future preview(String direction) async {
    const double parallaxOffset = 0.1;
    Offset endOffset = const Offset(0, parallaxOffset);
    switch (direction) {
      case moveDown:
        endOffset = const Offset(0, parallaxOffset);
        break;
      case moveUp:
        endOffset = const Offset(0, -parallaxOffset);
        break;
      case moveRight:
        endOffset = const Offset(parallaxOffset, 0);
        break;
      case moveLeft:
        endOffset = const Offset(-parallaxOffset, 0);
        break;
    }

    animation = Tween<Offset>(begin: Offset.zero, end: endOffset)
        .animate(CurvedAnimation(parent: controller, curve: Curves.elasticIn));

    try {
      await controller.forward().orCancel.whenComplete(() async => await controller.reverse().orCancel);
    } on TickerCanceled catch (error) {
      // ignore: avoid_print
      print(
          '$error.\nMost likely because the user has switched to another\nIcon Preview or tapped on button twp times.');
    } on Exception catch (_exception) {
      // ignore: avoid_print
      print('User most likely has switched to another screen.\n$_exception');
    }
  }
}

class _AdaptiveIconState extends State<AdaptiveIcon> with SingleTickerProviderStateMixin {
  @override
  void deactivate() {
    super.deactivate();
    if (AdaptiveIcon.controller.isAnimating) {
      AdaptiveIcon.controller.stop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (AdaptiveIcon.controller.isAnimating) {
      AdaptiveIcon.controller
        ..stop()
        ..dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    AdaptiveIcon.controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800), reverseDuration: const Duration(milliseconds: 1000));
    AdaptiveIcon.animation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.1)).animate(AdaptiveIcon.controller);
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    final Uint8List foregroundImage = context.select((SetupIcon icon) => icon.adaptiveForeground);
    final Color backgroundColor = context.select((SetupIcon icon) => icon.adaptiveColor);
    final bool preferColorBg = context.select((SetupIcon icon) => icon.preferColorBg);

    return AnimatedBuilder(
      animation: AdaptiveIcon.controller,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          if (!widget.onDevice) const TransparencyGrid(),
          if (backgroundImage != NullSafeValues.zeroBytes || backgroundColor != NullSafeValues.noColor)
            FractionallySizedBox(
              widthFactor: 0.7,
              heightFactor: 0.7,
              child: SlideTransition(
                  position: AdaptiveIcon.animation,
                  child: Transform.scale(
                      scale: 2.14,
                      child: preferColorBg
                          ? Container(color: backgroundColor)
                          : (backgroundImage != NullSafeValues.zeroBytes)
                              ? Image.memory(backgroundImage)
                              : const SizedBox.shrink())),
            ),
          SlideTransition(
              position: AdaptiveIcon.animation,
              child: Transform.scale(
                  scale: 1.5,
                  child: (foregroundImage == NullSafeValues.zeroBytes)
                      ? const SizedBox.shrink()
                      : Image.memory(foregroundImage))),
        ],
      ),
    );
  }
}
