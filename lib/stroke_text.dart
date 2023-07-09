import 'package:flutter/material.dart';

class StrokeText extends StatefulWidget {
  final double strokeWidth;
  final String text;
  final double fontSize;
  const StrokeText(
      {super.key,
      this.strokeWidth = 7,
      required this.text,
      required this.fontSize});

  @override
  State<StrokeText> createState() => _StrokeTextState();
}

class _StrokeTextState extends State<StrokeText> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 描边文本
        Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = widget.strokeWidth
              ..color = Colors.black,
          ),
        ),
        // 白色文本
        Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
