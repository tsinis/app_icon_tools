import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';
import '../widgets/adaptive/alert_dialog.dart';
import '../widgets/adaptive/button.dart';
import 'chess_grid.dart';

class BaseIconPreview extends StatelessWidget {
  final bool supportTransparancy, canChangeShape, isAdaptive;

  const BaseIconPreview({
    Key key,
    this.supportTransparancy = true,
    this.canChangeShape = false,
    this.isAdaptive = false,
  }) : super(key: key);
  static const _topRadius = Radius.circular(42);
  static const _bottomRadius = Radius.circular(10);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            height: 240,
            width: 240,
            decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(_topRadius)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const ChessGrid(),
                // Container(height: 220, width: 220, color: Colors.amber),
                Container(
                    clipBehavior: Clip.antiAlias,
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: supportTransparancy ? Colors.transparent : Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(canChangeShape ? 11 : 39)),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: canChangeShape ? Colors.transparent : Colors.black12,
                      //       blurRadius: 4,
                      //       offset: const Offset(0, 2))
                      // ],
                    ),
                    child: context.watch<SetupIcon>().icon)
              ],
            ),
          ),
          Container(
            // clipBehavior: Clip.hardEdge,
            height: 60,
            width: 240,
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(bottomLeft: _bottomRadius, bottomRight: _bottomRadius)),
            child: AdaptiveButton(
              text: 'Background',
              onPressed: () => showDialog<void>(
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
                        enableAlpha: supportTransparancy,
                        showLabel: !UserInterface.isApple),
                  ),
                ),
              ),
            ),
          )
        ],
      );
}
