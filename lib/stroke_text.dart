import 'package:flutter/material.dart';

class StrokeText extends StatefulWidget {
  final double strokeWidth;
  final String text;
  final double fontSize;
  final Color strokeColor;
  final Color color;
  const StrokeText(
      {super.key,
      this.strokeWidth = 7,
      required this.text,
      required this.fontSize,
      this.strokeColor = const Color.fromARGB(255, 255, 255, 255),
      this.color = const Color.fromARGB(255, 192, 1, 1)});

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
            fontFamily: 'SourceHanSansCN',
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = widget.strokeWidth
              ..color = widget.strokeColor,
          ),
        ),
        // 白色文本
        Text(
          widget.text,
          style: TextStyle(
            fontFamily: 'SourceHanSansCN',
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700,
            color: widget.color,
          ),
        ),
      ],
    );
  }
}
