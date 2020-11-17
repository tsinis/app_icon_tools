import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';

class IssuesInfo extends StatefulWidget {
  const IssuesInfo({Key key}) : super(key: key);

  @override
  _IssuesInfo createState() => _IssuesInfo();
}

class _IssuesInfo extends State<IssuesInfo> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    final CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.linear);
    // ignore: prefer_int_literals
    animation = Tween(begin: 0.3, end: 1.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double hue = context.select((SetupIcon icon) => icon.hue);
    final String issues = context.select((SetupIcon icon) => icon.issues);

    return (issues.isEmpty)
        ? const SizedBox(width: 28)
        : Tooltip(
            showDuration: Duration(seconds: 2 * ('\n'.allMatches(issues).length + 3)),
            decoration: BoxDecoration(
                color: Theme.of(context).bottomAppBarColor.withOpacity(0.84),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            textStyle: Theme.of(context).textTheme.button,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            message: '$issues\n',
            child: FadeTransition(
              opacity: animation,
              child: Icon(
                  UserInterface.isApple
                      ? CupertinoIcons.exclamationmark_triangle
                      : CommunityMaterialIcons.alert_outline,
                  color: HSLColor.fromAHSL(1, hue, 1, 0.45).toColor()),
            ),
          );
  }
}
