import 'package:flutter/material.dart';

class ChessGrid extends StatelessWidget {
  const ChessGrid({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 0.1,
        child: GridView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: 64,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (context, index) {
              final int xIndex = index % 8;
              final int yIndex = (index / 8).floor();
              return Container(color: (xIndex + yIndex).isEven ? Colors.grey : Colors.white);
            }),
      );
}
