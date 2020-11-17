import 'package:flutter/material.dart';

class TransparencyGrid extends StatelessWidget {
  const TransparencyGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: 64,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
      itemBuilder: (_, index) {
        final int xIndex = index % 8;
        final int yIndex = (index / 8).floor();
        return Container(color: (xIndex + yIndex).isEven ? const Color(0x80BFBFBF) : const Color(0x80FFFFFF));
      });
}
