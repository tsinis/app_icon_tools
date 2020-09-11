import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../widgets/adaptive/platform_navigation_bar.dart';
import 'background_view.dart';

class SnapClipPageView extends StatefulWidget {
  const SnapClipPageView({
    @required this.backgroundBuilder,
    @required this.itemBuilder,
    @required this.length,
    Key key,
    this.backgroundDecoration = const BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.white, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [.35, .8]),
    ),
  }) : super(key: key);

  final Decoration backgroundDecoration;
  final int length;

  @override
  _SnapClipPageViewState createState() => _SnapClipPageViewState();

  final BackgroundWidget Function(BuildContext context, int index) backgroundBuilder;

  final PageViewItem Function(BuildContext context, int index) itemBuilder;
}

class _SnapClipPageViewState extends State<SnapClipPageView> {
  SetupIcon iconProvider;

  @override
  void didChangeDependencies() {
    iconProvider = Provider.of<SetupIcon>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    iconProvider.pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<SetupIcon>().initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Stack(children: List.generate(widget.length, (index) => widget.backgroundBuilder(context, index))),
          Positioned.fill(child: Container(decoration: widget.backgroundDecoration)),
          PageView.builder(
              onPageChanged: iconProvider.setPlatform,
              controller: iconProvider.pageController,
              itemCount: widget.length,
              itemBuilder: widget.itemBuilder),
          const AdaptiveNavgationBar(),
        ],
      );
}

class PageViewItem extends StatefulWidget {
  const PageViewItem(
      {@required this.index,
      @required this.child,
      @required this.height,
      this.alignment = Alignment.bottomCenter,
      this.padding = const EdgeInsets.all(25),
      this.margin = const EdgeInsets.only(right: 8, left: 8),
      this.buildDecoration,
      Key key})
      : super(key: key);

  final AlignmentGeometry alignment;
  final Widget child;
  final double height;
  final int index;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  _PageViewItemState createState() => _PageViewItemState();

  final Decoration Function(double animation) buildDecoration;
}

class _PageViewItemState extends State<PageViewItem> {
  PageController foregroundPageController;
  double heightScale = 1;
  final double maxOpacityPoint = .4;
  final maxScalePoint = .1;
  final double minOpacity = .6;
  final minScaleSize = 1.0;
  double opacity = .6;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    foregroundPageController = context.read<SetupIcon>().pageController..addListener(onChangePage);
  }

  @override
  void dispose() {
    foregroundPageController.removeListener(onChangePage);
    super.dispose();
  }

  void onChangePage() {
    final double page = foregroundPageController.page;
    bool shouldSetState = false;
    double currentScale;
    if (page.ceil() == widget.index) {
      currentScale = page - (widget.index - 1);
      shouldSetState = true;
    } else if (page.floor() == widget.index) {
      currentScale = (widget.index + 1) - page;
      shouldSetState = true;
    }

    if (shouldSetState) {
      final double maxOpacity = currentScale * maxOpacityPoint + minOpacity;
      opacity = math.max(minOpacity, maxOpacity);

      final double maxSize = currentScale * maxScalePoint + minScaleSize;
      heightScale = math.max(minScaleSize, maxSize);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Align(
        alignment: widget.alignment,
        child: Container(
            height: widget.height * heightScale,
            decoration: widget.buildDecoration != null
                ? widget.buildDecoration(opacity)
                : BoxDecoration(color: Colors.white.withOpacity(opacity), borderRadius: BorderRadius.circular(25)),
            padding: widget.padding,
            margin: widget.margin,
            child: widget.child),
      );
}
