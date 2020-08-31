import 'package:flutter/widgets.dart';

import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const AdaptiveScaffold(child: Center(child: Text('Second screen!')));
  //TODO: Pass here icon file from first model.
}
