import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'network_controller.dart';
import 'sms_verification_code_login_page.dart';

class MyData extends StatefulWidget {
  const MyData({super.key});

  @override
  State<MyData> createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  NetworkController networkController = Get.find<NetworkController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.to(() => SMSVerificationCodeLoginPage());
          },
          child: const Text('Go to Login Page'),
        ),
        ElevatedButton(
          onPressed: () {
            networkController.toPay();
          },
          child: const Text('支付测试'),
        )
      ],
    ));
  }
}
