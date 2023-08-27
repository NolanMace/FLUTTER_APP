import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/back_home.dart';

class NormalAppBar extends StatelessWidget {
  final bool isBackToHome;
  final Widget body;
  const NormalAppBar(
      {super.key, this.isBackToHome = false, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => isBackToHome ? BackHome.backHome() : Get.back(),
          child: Image.asset(
            'assets/images/back.png',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 4, 6),
        toolbarHeight: 52,
      ),
      body: body,
    );
  }
}
