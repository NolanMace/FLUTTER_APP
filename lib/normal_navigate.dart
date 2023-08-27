import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'stroke_text.dart';

class NavigateContainer extends StatelessWidget {
  final controller;
  const NavigateContainer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            controller.clickNavigate(0);
          },
          child: Obx(() => NavigateButton(
                isSelected: controller.unUse.value,
                text: '待使用',
              )),
        ),
        GestureDetector(
          onTap: () {
            controller.clickNavigate(1);
          },
          child: Obx(() => NavigateButton(
                isSelected: controller.used.value,
                text: '已使用',
              )),
        ),
        GestureDetector(
          onTap: () {
            controller.clickNavigate(2);
          },
          child: Obx(() => NavigateButton(
                isSelected: controller.expired.value,
                text: '已失效',
              )),
        ),
      ],
    );
  }
}

class NavigateButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  const NavigateButton(
      {super.key, required this.isSelected, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      padding: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(isSelected
              ? 'assets/images/buttonCard.png'
              : 'assets/images/cardBgUnselected.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: isSelected
            ? StrokeText(
                text: text,
                fontSize: 16,
                color: const Color.fromARGB(255, 255, 255, 255),
                strokeColor: const Color.fromARGB(255, 192, 1, 1),
                strokeWidth: 3,
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SourceHanSansCN',
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 125, 120, 113),
                ),
              ),
      ),
    );
  }
}
