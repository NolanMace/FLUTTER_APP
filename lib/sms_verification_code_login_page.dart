import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/lzyf_check_box.dart';
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
  final phoneController = TextEditingController();
  final verificationCodeController = TextEditingController();
  var errorText = ''.obs;

  //是否同意协议
  var isAgree = false.obs;
  void agree() {
    isAgree.value = !isAgree.value;
  }

  JverifyController jverifyController = Get.find<JverifyController>();
  NetworkController networkController = Get.find<NetworkController>();

  Widget changeMenuButtonToCN(context, editableTextState) {
    return AppConfig().changeMenuButtonToCN(context, editableTextState);
  }

  bool isValidPhoneNumber() {
    // 使用正则表达式验证手机号码格式
    // 中国大陆手机号码格式为 11 位数字，以 13、14、15、16、17、18、19 开头
    // 注意：这里只是简单的验证格式，不能保证号码一定是真实存在的
    final RegExp regex = RegExp(r'^1[3-9]\d{9}$');
    return regex.hasMatch(phoneController.text);
  }

  void startCountdown() {
    if (!isValidPhoneNumber()) {
      EasyLoading.showToast('请输入正确的手机号码');
      return;
    }
    networkController.sendSMSCodeRequest(phoneController.text);
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

  void login() async {
    // 实现登录逻辑
    if (!isValidPhoneNumber()) {
      EasyLoading.showToast('请输入正确的手机号码');
      return;
    } else if (verificationCodeController.text.isEmpty) {
      EasyLoading.showToast('请输入验证码');
      return;
    } else if (!isAgree.value) {
      EasyLoading.showToast('请同意用户协议');
      return;
    }
    errorText.value = await networkController.smsLoginRequest(
        phoneController.text, verificationCodeController.text);
    errorText.refresh();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            '短信验证码登录',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceHanSansCN',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                  TextField(
                    contextMenuBuilder: (context, editableTextState) =>
                        _controller.changeMenuButtonToCN(
                            context, editableTextState),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    controller: controller.phoneController,
                    maxLength: 20,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        focusColor: Colors.white,
                        prefixIcon: Icon(Icons.phone,
                            color: Colors.white,
                            size: 20,
                            semanticLabel: '手机号'),
                        hintText: '请输入手机号',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )),
                  ),
                  const SizedBox(height: 16.0),
                  Obx(
                    () => TextField(
                      contextMenuBuilder: (context, editableTextState) =>
                          _controller.changeMenuButtonToCN(
                              context, editableTextState),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      controller: controller.verificationCodeController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          focusColor: Colors.white,
                          prefixIcon: const Icon(Icons.sms_outlined,
                              color: Colors.white,
                              size: 20,
                              semanticLabel: '验证码'),
                          hintText: '请输入验证码',
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffix: VerificationCodeButton(),
                          errorText: _controller.errorText.value),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: _controller.login,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 192, 1, 1)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(180, 40)),
                      ),
                      child: const Text('登录', style: TextStyle(fontSize: 18))),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        _controller.switchLoginAuto();
                      },
                      child: const Text(
                        '手机号一键登录',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SourceHanSansCN',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      )),
                ],
              ),
            ),
            Positioned(
                bottom: 100,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 20,
                          height: 20,
                          child: LzyfCheckBox(
                              value: _controller.isAgree.value,
                              onChanged: () => _controller.agree()),
                        ),
                      ),
                      const Text(
                        '我已阅读并同意',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SourceHanSansCN',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/agreementPage'),
                        child: const Text(
                          '《用户协议》',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SourceHanSansCN',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
