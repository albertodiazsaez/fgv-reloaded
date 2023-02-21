import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';

class LineNumber extends StatelessWidget {
  const LineNumber(this.lineNumber, this.color, this.size, {Key? key})
      : super(key: key);

  final int lineNumber;
  final HexColor color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(size / 5))),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5),
      height: size,
      width: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          lineNumber.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              // Custom height breakes centering, when Flutter fixes it, make the Text bigger.
              height: 0,
              fontSize: size * 100,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
