import 'package:flutter/widgets.dart';

import '../widgets/adaptive/scaffold_app_bar.dart';
import '../widgets/drag_and_drop.dart';

class InitialUploadScreen extends StatelessWidget {
  const InitialUploadScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const AdaptiveScaffold(
        uploadScreen: true,
        child:
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            Center(child: Hero(tag: 'global', child: DragAndDrop())),
        //   ],
        // ),
      );
}
