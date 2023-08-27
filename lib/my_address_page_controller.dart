import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/to_login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAddressPageController extends ToLoginController {
  final Dio dio = Dio();
  final String getAddressUrl = AppConfig.getAddressesByUserId;
  final String deleteAddressUrl = AppConfig.deleteAddress;
  final String updateAddressUrl = AppConfig.updateAddress;

  bool isFromCarbinet = false;

  var myAddresses = [].obs;

  void getMyAddresses() async {
    try {
      isRequesting.value = true;
      isRequesting.refresh();
      final options = await AppConfig.getOptions();
      if (options == null) {
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      final res = await dio.get(getAddressUrl, options: options);
      if (res.statusCode == 401) {
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      if (res.statusCode != 200) {
        EasyLoading.showError('获取地址失败,状态码${res.statusCode},错误信息${res.data}');
        return;
      }
      isLogged.value = true;
      if (res.statusCode == 200 && res.data != null) {
        myAddresses.value = res.data;
      }
      refresh();
    } catch (e) {
      print(e);
    } finally {
      isRequesting.value = false;
      isRequesting.refresh();
    }
  }

  void deleteAddress(address) async {
    try {
      final options = await AppConfig.getOptions();
      if (options == null) {
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      final res =
          await dio.delete(deleteAddressUrl, options: options, data: address);
      if (res.statusCode == 401) {
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      if (res.statusCode != 200) {
        EasyLoading.showError('删除地址失败,状态码${res.statusCode},错误信息${res.data}');
        return;
      }
      EasyLoading.showSuccess('删除地址成功');
      getMyAddresses();
    } catch (e) {
      print(e);
    }
  }

  void updateAddress(address) async {
    var res =
        await Get.toNamed('/myAddressPage/addAddress', arguments: address);
    if (res != null) {
      getMyAddresses();
    }
  }

  void addNewAddress() async {
    var res = await Get.toNamed('/myAddressPage/addAddress');
    if (res != null) {
      getMyAddresses();
    }
  }

  void setAddressAsDefault(address) async {
    //把address保存在本地
    final prefs = await SharedPreferences.getInstance();
    var addressString = json.encode(address);
    prefs.setString('defaultAddress', addressString);
    EasyLoading.showSuccess('设置默认地址成功');
  }

  Future getMyDefaultAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultAddress = prefs.getString('defaultAddress');
      if (defaultAddress == null) {
        return {};
        //把defaultAddress转换成Map
      }
      return json.decode(defaultAddress);
    } catch (e) {
      print(e);
      return {};
    }
  }

  void selectAddress(address) {
    print(address);
    if (isFromCarbinet) {
      Get.back(result: address);
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments == 'fromCarbinet') {
      isFromCarbinet = true;
    }
    getMyAddresses();
  }

  @override
  void onClose() {
    super.onClose();
    dio.close();
  }
}
