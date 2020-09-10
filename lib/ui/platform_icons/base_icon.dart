import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';
import '../widgets/adaptive/alert_dialog.dart';
import '../widgets/adaptive/button.dart';
import '../widgets/adaptive/slider.dart';
import 'transparency_grid.dart';

class IconPreview extends StatelessWidget {
  final int cornerRadius, platformID;

  const IconPreview({Key key, this.cornerRadius, this.platformID}) : super(key: key);

  const IconPreview.newAndroid({this.cornerRadius}) : platformID = 0;

  const IconPreview.oldAndroid({this.cornerRadius}) : platformID = 1;

  const IconPreview.iOS()
      : cornerRadius = 39,
        platformID = 2;

  const IconPreview.web()
      : cornerRadius = 0,
        platformID = 3;

  const IconPreview.windows()
      : cornerRadius = 0,
        platformID = 4;

  const IconPreview.linux()
      : cornerRadius = 0,
        platformID = 5;

  const IconPreview.macOS()
      : cornerRadius = 0,
        platformID = 6;

  // const IconPreview.fuchsiaOS()
  //     : cornerRadius = 20,
  //       platformID = 7;

  double get _staticCornerRadius => cornerRadius.toDouble();

  bool get _canChangeShape => cornerRadius == null;

  bool get _isAdaptive => platformID == 0;

  bool get _supportTransparency => platformID != 2;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_types_on_closure_parameters
    final double _androidCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_canChangeShape)
          SizedBox(
            width: 240,
            child: AdaptiveSlider(
                value: _androidCornerRadius,
                // label: _androidCornerRadius.round().toString(),
                onChanged: (_newRadius) => context.read<SetupIcon>().setRadius(_newRadius)),
          )
        else
          const SizedBox(height: 42),
        Container(
          clipBehavior: Clip.hardEdge,
          height: 220,
          width: 220,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius:
                  BorderRadius.all(Radius.circular(_canChangeShape ? _androidCornerRadius : _staticCornerRadius))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const TransparencyGrid(),
              Container(
                  color: _supportTransparency ? Colors.transparent : Colors.black,
                  child: context.watch<SetupIcon>().icon)
            ],
          ),
        ),
        Container(
          height: 72,
          width: 240,
          color: Colors.transparent,
          child: AdaptiveButton(
            text: 'Background',
            onPressed: () => _isAdaptive
                ? context.read<SetupIcon>().goTo(3)
                : showDialog<void>(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: AdaptiveDialog(
                        title: 'Icon Background Color',
                        leftButton: 'Remove',
                        rightButton: 'Add Background',
                        onPressedLeft: () => print('Pressed Left Button'),
                        onPressedRight: () => print('Pressed Right Button'),
                        content: ColorPicker(
                            pickerColor: const Color(0xFF418581),
                            onColorChanged: (_newColor) => print(_newColor.toString()),
                            pickerAreaHeightPercent: 0.8,
                            displayThumbColor: true,
                            portraitOnly: UserInterface.isApple,
                            enableAlpha: _supportTransparency,
                            showLabel: !UserInterface.isApple),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
