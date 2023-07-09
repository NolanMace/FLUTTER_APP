import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/network_controller.dart';
import 'jverify_controller.dart';

// class SMSCodeController extends GetxController {
//   final int countdownDuration = 60;
//   RxInt countdown = 0.obs;
//   RxBool isButtonDisabled = false.obs;
//   Timer? countdownTimer;

//   bool isValidPhoneNumber(String phoneNumber) {
//     // 使用正则表达式验证手机号码格式
//     // 中国大陆手机号码格式为 11 位数字，以 13、14、15、16、17、18、19 开头
//     // 注意：这里只是简单的验证格式，不能保证号码一定是真实存在的
//     final RegExp regex = RegExp(r'^1[3-9]\d{9}$');
//     return regex.hasMatch(phoneNumber);
//   }

//   void startCountdown() {
//     LoginController loginController = Get.find<LoginController>();
//     var phoneNumber = loginController.phoneNumber.value;
//     JverifyController jverifyController = Get.find<JverifyController>();
//     if (!isValidPhoneNumber(phoneNumber)) {
//       Get.snackbar('提示', '请输入正确的手机号码',
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.only(bottom: 20));
//       return;
//     }
//     jverifyController.getSMSCode(phoneNumber);
//     countdown.value = countdownDuration;
//     isButtonDisabled.value = true;

//     countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countdown.value == 0) {
//         stopCountdown();
//       } else {
//         countdown.value--;
//       }
//     });
//   }

//   void stopCountdown() {
//     countdownTimer?.cancel();
//     countdown.value = 0;
//     isButtonDisabled.value = false;
//   }

//   @override
//   void onClose() {
//     countdownTimer?.cancel();
//     super.onClose();
//   }
// }

class VerificationCodeButton extends StatelessWidget {
  final LoginController countdownController = Get.find<LoginController>();

  VerificationCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: countdownController.isButtonDisabled.value
            ? null
            : countdownController.startCountdown,
        child: Text(
            countdownController.countdown.value > 0
                ? '倒计时 ${countdownController.countdown.value}s'
                : '获取验证码',
            style: countdownController.isButtonDisabled.value
                ? const TextStyle(
                    color: Colors.grey,
                  )
                : const TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Colors.red,
                    decorationThickness: 2.0,
                  )),
      ),
    );
  }
}

class LoginController extends GetxController {
  final int countdownDuration = 60;
  RxInt countdown = 0.obs;
  RxBool isButtonDisabled = false.obs;
  Timer? countdownTimer;
  var phoneNumber = ''.obs;
  var verificationCode = ''.obs;
  JverifyController jverifyController = Get.find<JverifyController>();
  NetworkController networkController = Get.find<NetworkController>();

  bool isValidPhoneNumber() {
    // 使用正则表达式验证手机号码格式
    // 中国大陆手机号码格式为 11 位数字，以 13、14、15、16、17、18、19 开头
    // 注意：这里只是简单的验证格式，不能保证号码一定是真实存在的
    final RegExp regex = RegExp(r'^1[3-9]\d{9}$');
    return regex.hasMatch(phoneNumber.value);
  }

  void startCountdown() {
    if (!isValidPhoneNumber()) {
      Get.snackbar('提示', '请输入正确的手机号码',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 20));
      return;
    }
    networkController.sendSMSCodeRequest(phoneNumber.value);
    countdown.value = countdownDuration;
    isButtonDisabled.value = true;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value == 0) {
        stopCountdown();
      } else {
        countdown.value--;
      }
    });
  }

  void stopCountdown() {
    countdownTimer?.cancel();
    countdown.value = 0;
    isButtonDisabled.value = false;
  }

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
  }

  void updateVerificationCode(String value) {
    verificationCode.value = value;
  }

  void login() {
    // 实现登录逻辑
    if (!isValidPhoneNumber()) {
      Get.snackbar('提示', '请输入正确的手机号码',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 20));
      return;
    } else if (verificationCode.value.isEmpty) {
      Get.snackbar('提示', '请输入验证码',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 20));
      return;
    }
    networkController.smsLoginRequest(
        phoneNumber.value, verificationCode.value);
  }

  void switchLoginAuto() {
    jverifyController.loginAuth();
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }
}

class SMSVerificationCodeLoginPage extends GetView<LoginController> {
  SMSVerificationCodeLoginPage({super.key});

  final LoginController _controller = Get.put(LoginController());
  final JverifyController jverifyController = Get.find<JverifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: _controller.updatePhoneNumber,
              decoration: const InputDecoration(
                labelText: '手机号',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: _controller.updateVerificationCode,
              decoration: const InputDecoration(
                labelText: '验证码',
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: VerificationCodeButton(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: _controller.login,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text('登录')),
            ElevatedButton(
                onPressed: _controller.switchLoginAuto,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text('手机号一键登录')),
          ],
        ),
      ),
    );
  }
}
