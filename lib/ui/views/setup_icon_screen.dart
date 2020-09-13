import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:launcher_icons_gui/ui/platform_icons/icon.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../custom_pageviews/background_view.dart';
import '../custom_pageviews/icon_view.dart';
import '../platform_icons/platforms_list.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('Second Screen build');
    return AdaptiveScaffold(
      child: SnapClipPageView(
        backgroundBuilder: _buildBackground,
        itemBuilder: _buildChild,
        length: platformList.length,
        backgroundDecoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey[600], Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [.1, .5]),
        ),
      ),
    );
  }

  BackgroundWidget _buildBackground(BuildContext context, int index) => BackgroundWidget(
        index: index,
        child: Stack(
          alignment: Alignment.center,
          children: [
            WebsafeSvg.asset(
              platformList[index].devicePicture,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.06,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(11))),
                child: IconWithShape(onDevice: true, supportTransparency: platformList[index].platformID != 2)),
          ],
        ),
      );

  PageViewItem _buildChild(BuildContext context, int index) => PageViewItem(
      buildDecoration: _decoration,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(40),
      height: 340,
      index: index,
      child: platformList[index]);

  Decoration _decoration(double _) => const BoxDecoration(color: Colors.transparent);
}
