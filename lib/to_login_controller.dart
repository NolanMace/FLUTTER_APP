import 'package:get/get.dart';

import 'to_login.dart';

class ToLoginController extends GetxController {
  var isLogged = false.obs;
  var isRequesting = false.obs;

  void toLogin() {
    if (isLogged.value) {
      return;
    }
    ToLogin.toLogin();
  }

  void doSomething() {}

  @override
  void onClose() {
    super.onClose();
    doSomething();
  }
}
