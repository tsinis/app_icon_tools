import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('Second Screen build');
    return AdaptiveScaffold(
      child: Center(
        child: SizedBox(width: 200, height: 200, child: context.watch<SetupIcon>().icon),
      ),
    );
  }
}
