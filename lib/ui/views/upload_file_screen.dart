import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../models/user_interface.dart';

import '../widgets/adaptive/scaffold_app_bar.dart';
import '../widgets/drag_and_drop.dart';

class InitialUploadScreen extends StatelessWidget {
  const InitialUploadScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const AdaptiveScaffold(
      uploadScreen: true, child: Center(child: Hero(tag: 'global', child: _HeroWorkaround(child: DragAndDrop()))));
}

//TODO: Check when https://github.com/flutter/flutter/issues/36220 is closed.
class _HeroWorkaround extends StatelessWidget {
  const _HeroWorkaround({@required this.child, Key key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      UserInterface.isApple ? SizedBox(child: child) : Material(type: MaterialType.transparency, child: child);
}
