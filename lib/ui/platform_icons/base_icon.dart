import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'chess_grid.dart';

class BaseIconPreview extends StatelessWidget {
  final bool noTransparancy, canChangeShape, isAdaptive;

  const BaseIconPreview({
    Key key,
    this.noTransparancy = false,
    this.canChangeShape = false,
    this.isAdaptive = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 200,
          width: 200,
          decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(34))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const ChessGrid(),
              Container(
                  clipBehavior: Clip.antiAlias,
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                          color: canChangeShape ? Colors.transparent : Colors.black26,
                          blurRadius: 2,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: context.watch<SetupIcon>().icon)
            ],
          ),
        ),
      ],
    );
  }
}
