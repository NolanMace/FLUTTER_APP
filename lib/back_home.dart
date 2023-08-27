import 'package:get/get.dart';
import 'main.dart';

class BackHome {
  static void backHome({int index = 0}) {
    var myAppController = Get.find<MyAppController>();
    myAppController.changeInitiaPage(index);
    Get.offAllNamed('/MyApp');
  }
}
