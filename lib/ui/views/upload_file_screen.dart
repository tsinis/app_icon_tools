import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../models/user_interface.dart';

import '../widgets/adaptive/scaffold_and_app_bar.dart';
import '../widgets/drag_and_drop.dart';

class InitialUploadScreen extends StatelessWidget {
  const InitialUploadScreen();

  @override
  Widget build(BuildContext context) => const AdaptiveScaffold(
      uploadScreen: true, child: Center(child: Hero(tag: 'global', child: _HeroWorkaround(child: DragAndDrop()))));
}

//TODO: Check when https://github.com/flutter/flutter/issues/36220 is closed.
class _HeroWorkaround extends StatelessWidget {
  const _HeroWorkaround({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      UserInterface.isCupertino ? SizedBox(child: child) : Material(type: MaterialType.transparency, child: child);
}
