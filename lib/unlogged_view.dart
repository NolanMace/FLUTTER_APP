import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnloggedView extends StatelessWidget {
  final controller;
  const UnloggedView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !controller.isLogged.value && !controller.isRequesting.value,
        child: Expanded(
            child: Center(
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 118, 0, 0))),
              onPressed: () => controller.toLogin(),
              child: const Text(
                '点击登录查看更多内容',
                style: TextStyle(fontSize: 16, color: Colors.white),
              )),
        )),
      ),
    );
  }
}
