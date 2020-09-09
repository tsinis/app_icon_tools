import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({@required this.child, @required this.index, Key key}) : super(key: key);

  final Widget child;
  final int index;

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  PageController backgroundPageController;
  double page = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    backgroundPageController = context.read<SetupIcon>().pageController..addListener(onChangeListner);
  }

  @override
  void dispose() {
    backgroundPageController.removeListener(onChangeListner);
    super.dispose();
  }

  void onChangeListner() {
    final cp = backgroundPageController.page;
    if (cp.ceil() == widget.index) {
      setState(() => page = cp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = widget.child;
    return Positioned.fill(
        child: widget.index == 0 ? child : ClipPath(clipper: _BackgroundClipper(page, widget.index), child: child));
  }
}

class _BackgroundClipper extends CustomClipper<Path> {
  _BackgroundClipper(this.clipValue, this.index);

  final double clipValue;
  final int index;

  @override
  Path getClip(Size size) {
    final double width = size.width * (clipValue - (index - 1));
    final Path path = Path()..lineTo(width, 0)..lineTo(width, size.height)..lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(_BackgroundClipper oldClipper) => clipValue.ceil() == index;
}
