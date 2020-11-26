import 'package:flutter/material.dart';

class TransparencyGrid extends StatelessWidget {
  const TransparencyGrid({Key key}) : super(key: key);
  static const int _gridsCount = 8;
  @override
  Widget build(BuildContext context) => GridView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: _gridsCount * _gridsCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _gridsCount),
      itemBuilder: (_, index) {
        final int xIndex = index % _gridsCount;
        final int yIndex = (index / _gridsCount).floor();
        return Container(color: (xIndex + yIndex).isEven ? const Color(0x80BFBFBF) : const Color(0x80FFFFFF));
      });
}
