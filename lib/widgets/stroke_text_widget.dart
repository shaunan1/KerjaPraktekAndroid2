import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color strokeColor;
  final Color innerColor;
  final double height;
  final double letterSpacing;
  final TextAlign textAlign;

  const StrokeText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.strokeColor,
    required this.innerColor,
    required this.height,
    required this.letterSpacing,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = strokeColor,
            height: height,
            letterSpacing: letterSpacing,
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: innerColor,
            height: height,
            letterSpacing: letterSpacing,
          ),
        ),
      ],
    );
  }
}
