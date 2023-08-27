import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/state_manager.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/back_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/tobias.dart';

class NetworkController extends GetxController {
  final loginUrl = AppConfig.loginUrl;
  final appId = AppConfig.appId;
  final alipayUrl = AppConfig.alipayUrl;
  Future<void> saveDataToCache(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> loginAuthRequest(loginToken) async {
    try {
      Response response = await Dio()
          .post(loginUrl, data: {"loginToken": loginToken, "app_id": appId});
      print(response.data);
      if (response.statusCode == 200) {
        String token = response.data['token'];
        await saveDataToCache('token', token);
        EasyLoading.showToast('登录成功');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendSMSCodeRequest(phone) async {
    try {
      Response response = await Dio().post(AppConfig.appSendSMSCode,
          data: {"phone": phone, "appId": appId});
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<String> smsLoginRequest(phone, smsCode) async {
    EasyLoading.show(
        status: '登录中...',
        indicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 192, 1, 1),
        ));
    try {
      Response response = await Dio().post(AppConfig.smsLoginUrl,
          data: {"phone": phone, "code": smsCode, "app_id": appId});
      print(response.data);
      if (response.statusCode != 200) {
        EasyLoading.showToast('登录失败');
        return '验证码错误';
      }
      String token = response.data['token'];
      await saveDataToCache('token', token);
      EasyLoading.showToast('登录成功');
      BackHome.backHome();
      return '';
    } catch (e) {
      EasyLoading.showToast('登录失败');
      print(e);
      return '验证码错误';
    }
  }

  void toPay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      //获取名为“token”的值，如果该键不存在，则返回默认值null
      final token = prefs.getString('token');
      // 处理获取的值
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      Response response = await Dio().post(alipayUrl, options: options, data: {
        'app_id': "1",
        'box_id': 21,
        'box_number': 2,
        'lottery_count': 1,
        'pay_type': "box",
        'payment_amount': 1,
        'shipment_address': "ksl,13777821097,广东省,广州市,海珠区,海滨花园",
        'total_amount': 1,
        'user_coupon_id': 0,
        'xbean': 0
      });
      Tobias tobias = Tobias();
      print(response.data.toString());
      tobias.pay(response.data['payParam'].toString());
    } catch (e) {
      print(e);
    }
  }
}
