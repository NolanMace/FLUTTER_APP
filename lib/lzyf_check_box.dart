import 'package:flutter/material.dart';

class LzyfCheckBox extends StatelessWidget {
  final bool value;
  final Function onChanged;
  const LzyfCheckBox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged();
      },
      child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            value ? 'assets/images/select.png' : 'assets/images/unSelect.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          )),
    );
  }
}

class LzyfCheckboxWithNoOnTap extends StatelessWidget {
  final bool value;
  const LzyfCheckboxWithNoOnTap({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          value ? 'assets/images/select.png' : 'assets/images/unSelect.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
  }
}
