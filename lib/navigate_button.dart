import 'package:flutter/material.dart';
import 'stroke_text.dart';

class NavigateButton extends StatefulWidget {
  final bool isSelected;
  final String text;
  final double fontSize;
  final double strokeWidth;
  const NavigateButton(
      {super.key,
      this.isSelected = true,
      required this.text,
      this.fontSize = 16,
      this.strokeWidth = 4});

  @override
  State<NavigateButton> createState() => _NavigateButtonState();
}

class _NavigateButtonState extends State<NavigateButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isSelected
        ? StrokeText(
            text: widget.text,
            fontSize: widget.fontSize,
            strokeWidth: widget.strokeWidth)
        : Text(widget.text,
            style: TextStyle(
                fontSize: widget.fontSize,
                color: const Color.fromARGB(255, 110, 106, 106),
                fontWeight: FontWeight.w900));
  }
}
