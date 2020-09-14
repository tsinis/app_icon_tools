import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../platform_icons/icon.dart';
import '../platform_icons/platforms_list.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';
import '../widgets/layout.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _portrait = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    // print('Second Screen build');
    return AdaptiveScaffold(
        child: Center(
      child: PreviewLayout(
        portraitOrientation: _portrait,
        children: [
          platformList[1],
          FittedBox(
            fit: BoxFit.contain,
            child: Row(
              children: [
                // const SizedBox(width: 60),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WebsafeSvg.asset(platformList[0].devicePicture, fit: BoxFit.contain, height: 640),
                    SizedBox(
                        height: 40,
                        width: 40,
                        child: IconWithShape(onDevice: true, supportTransparency: platformList[1].platformID != 2)),
                  ],
                ),
              ],
            ),
          )
        ],
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
