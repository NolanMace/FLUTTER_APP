import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewRecordsButtonsContainer extends StatelessWidget {
  final controller;
  const PreviewRecordsButtonsContainer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: 180,
        height: 43,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.clickSelect(0);
              },
              child: Image.asset(
                  !controller.selectedRecords.value
                      ? 'assets/images/preview.png'
                      : 'assets/images/previewUnselected.png',
                  width: 85,
                  height: 43,
                  fit: BoxFit.fill),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                controller.clickSelect(1);
              },
              child: Image.asset(
                controller.selectedRecords.value
                    ? 'assets/images/record.png'
                    : 'assets/images/recordUnselected.png',
                width: 85,
                height: 43,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}
