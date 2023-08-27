import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/to_login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MineIndexPageController extends ToLoginController {
  final Dio dio = Dio();
  final String getUserAvatarAndNicknameUrl =
      AppConfig.getUserAvatarAndNicknameByPhoneAndAppId;
  final String getUserXbeanUrl = AppConfig.getUserXbeanByAppIdAndPhone;

  var userData = {}.obs;
  var xbean = 0.0.obs;

  void getMyData() async {
    EasyLoading.show(
        status: '加载中...',
        indicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 192, 1, 1),
        ));
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        EasyLoading.dismiss();
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      final res = await dio.get(getUserAvatarAndNicknameUrl, options: options);
      if (res.statusCode != 200) {
        EasyLoading.dismiss();
        //处理登录逻辑
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      isLogged.value = true;
      userData.value = res.data;
      final res2 = await dio.get(getUserXbeanUrl, options: options);
      if (res2.statusCode == 200) {
        xbean.value = double.tryParse(res2.data['xbean'].toString())!;
      }
      EasyLoading.dismiss();
      refresh();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  void editUserData() {
    EasyLoading.showToast('请登录微信小程序端修改个人信息');
  }

  void toMyCoupon() {
    Get.toNamed('/myCouponPage');
  }

  void toShipmentManagement() {
    Get.toNamed('/myShipmentPage');
  }

  void toConsumeRecord() {
    Get.toNamed('/myConsumRecordsPage');
  }

  void toMyAddress() {
    print('toMyAddress');
    Get.toNamed('/myAddressPage');
  }

  void toUserAgreement() {
    Get.toNamed('/agreementPage');
  }

  void toYcShipment() {
    Get.toNamed('/ycShipmentPage');
  }

  //退出登录
  void logout() async {
    if (!isLogged.value) {
      EasyLoading.showToast('您还未登录');
      return;
    }
    Get.dialog(
      AlertDialog(
        title: const Text('提示'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              isLogged.value = false;
              isLogged.refresh();
              Get.back();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    getMyData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   dio.close();
  // }
}
