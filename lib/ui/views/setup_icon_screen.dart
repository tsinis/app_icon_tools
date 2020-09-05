import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snapclip_pageview/snapclip_pageview.dart';

import '../../models/setup_icon.dart';
import '../platform_icons/base_icon.dart';
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
        length: 2,
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
}

BackgroundWidget _buildBackground(BuildContext context, int index) =>
    BackgroundWidget(index: index, child: FittedBox(fit: BoxFit.cover, child: context.watch<SetupIcon>().icon));

PageViewItem _buildChild(BuildContext context, int index) => PageViewItem(
      buildDecoration: _decoration,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(40),
      height: 200,
      index: index,
      child: const BaseIconPreview(),
    );

Decoration _decoration(double _) => const BoxDecoration(color: Colors.transparent);
