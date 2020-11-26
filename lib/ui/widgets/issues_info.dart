import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:provider/provider.dart';

import '../../constants/platforms/platforms_list.dart';
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
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // ignore: prefer_int_literals
    animation = Tween(begin: 0.4, end: 1.0).animate(animationController)
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
                color: (CupertinoTheme.of(context).barBackgroundColor ?? Theme.of(context).bottomAppBarColor)
                    .withOpacity(0.9),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            textStyle: CupertinoTheme.of(context).textTheme.textStyle ?? Theme.of(context).textTheme.button,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            message: '$issues\n',
            child: FadeTransition(
              opacity: animation,
              child: _DesktopIconButton(Icon(
                  UserInterface.isCupertino
                      ? CupertinoIcons.exclamationmark_triangle
                      : CommunityMaterialIcons.alert_outline,
                  color: HSLColor.fromAHSL(1, hue, 1, 0.45).toColor())),
            ),
          );
  }
}

class _DesktopIconButton extends StatelessWidget {
  const _DesktopIconButton(this._icon, {Key key}) : super(key: key);
  final Icon _icon;
  @override
  Widget build(BuildContext context) {
    final int selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    return (platform.isMobile)
        ? _icon
        : IconButton(
            icon: _icon,
            onPressed: () async => await context.read<UserInterface>().showDocs(platformList[selectedPlatform].docs));
  }
}
