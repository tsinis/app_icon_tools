import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../models/setup_icon.dart';
import '../platform_icons/icon.dart';
import '../platform_icons/platforms_list.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({this.deviceID = 1, Key key}) : super(key: key);
  @required
  final int deviceID;
  @override
  Widget build(BuildContext context) {
    final bool _devicePreview = context.select((SetupIcon icon) => icon.devicePreview);
    // print('Second Screen build');
    return AdaptiveScaffold(
        child: GestureDetector(
      onTap: context.watch<SetupIcon>().changePreview,
      child: LocalHeroScope(
        duration: const Duration(seconds: 1),
        // createRectTween: (begin, end) => CustomRectTween(a: begin, b: end),
        curve: Curves.elasticOut,
        child: Center(
          child: _devicePreview
              ? FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    children: [
                      // const SizedBox(width: 60),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          WebsafeSvg.asset(platformList[deviceID].devicePicture, fit: BoxFit.contain, height: 640),
                          SizedBox(
                              height: 40,
                              width: 40,
                              child: IconWithShape(
                                  onDevice: true, supportTransparency: platformList[deviceID].platformID != 2)),
                        ],
                      ),
                    ],
                  ),
                )
              : platformList[deviceID],
        ),
      ),
    )

        // SnapClipPageView(
        //   backgroundBuilder: _buildBackground,
        //   itemBuilder: _buildChild,
        //   length: platformList.length,
        //   backgroundDecoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         colors: [Colors.grey[600], Colors.transparent],
        //         begin: Alignment.bottomCenter,
        //         end: Alignment.topCenter,
        //         stops: const [.1, .5]),
        //   ),
        // ),
        );
  }

  // BackgroundWidget _buildBackground(BuildContext context, int index) => BackgroundWidget(
  //       index: index,
  //       child: Transform.scale(
  //         alignment: const Alignment(0, -0.7),
  //         scale: 0.7,
  //         child: FittedBox(
  //           fit: BoxFit.contain,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               WebsafeSvg.asset(platformList[index].devicePicture, fit: BoxFit.contain, height: 640),
  //               SizedBox(
  //                   height: 40,
  //                   width: 40,
  //                   child: IconWithShape(onDevice: true, supportTransparency: platformList[index].platformID != 2)),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  // PageViewItem _buildChild(BuildContext context, int index) => PageViewItem(
  //     buildDecoration: _decoration,
  //     padding: const EdgeInsets.all(0),
  //     margin: const EdgeInsets.all(40),
  //     height: 340,
  //     index: index,
  //     child: platformList[index]);

  // Decoration _decoration(double _) => const BoxDecoration(color: Colors.transparent);
}
