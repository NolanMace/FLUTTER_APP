import 'package:get/get.dart';

import 'back_home.dart';
import 'jverify_controller.dart';

class ToLogin {
  static void toLogin() {
    final JverifyController jverifyController = Get.find();
    jverifyController.loginAuth();
    BackHome.backHome();
  }
}
