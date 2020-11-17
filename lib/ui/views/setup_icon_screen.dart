import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/constants/platforms_list.dart';
import '../../models/setup_icon.dart';
import '../widgets/adaptive/platform_navigation_bar.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AdaptiveScaffold(
        child: Column(
          children: [
            Expanded(child: platformList[context.select((SetupIcon icon) => icon.platformID)]),
            const AdaptiveNavgationBar()
          ],
        ),
      );
}
