import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lzyfs_app/to_login_controller.dart';

import 'app_config.dart';

class MyCouponPageController extends ToLoginController {
  final dio = Dio();
  final String getCouponsUrl = AppConfig.getUserCouponByAppIdAndPhone;

  var unUse = true.obs;
  var used = false.obs;
  var expired = false.obs;

  final unUsecoupons = [].obs;
  final usedCoupons = [].obs;
  final expeiredCoupon = [].obs;

  String convertDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

  void getMyCoupons() async {
    EasyLoading.show(
        status: '加载中...',
        indicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 192, 1, 1),
        ));
    try {
      isRequesting.value = true;
      isRequesting.refresh();
      var options = await AppConfig.getOptions();
      if (options == null) {
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        EasyLoading.dismiss();
        return;
      }
      final response = await Dio().get(
        getCouponsUrl,
        options: options,
      );
      if (response.statusCode == 401) {
        //处理登录逻辑
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        EasyLoading.dismiss();
        return;
      }
      if (response.statusCode != 200) {
        EasyLoading.dismiss();
        EasyLoading.showError('获取优惠券失败');
        return;
      }
      isLogged.value = true;
      final rawData = response.data;
      var rawunUseCoupons = [];
      var rawusedCoupons = [];
      var rawexpeiredCoupons = [];
      if (rawData == null) {
        EasyLoading.dismiss();
        return;
      }
      for (var item in rawData) {
        final coupon = {
          'user_coupon_id': item['user_coupon_id'],
          'minimum_order_amount': item['minimum_order_amount'] == null ||
                  item['minimum_order_amount'] == 0
              ? '0.00'
              : double.parse(item['minimum_order_amount'].toString())
                  .toStringAsFixed(2),
          'description': item['description'],
          'coupon_status': item['coupon_status'],
          'coupon_name': item['coupon_name'],
        };
        if (item['coupon_type'] == '1') {
          coupon['start_date'] = convertDateTime(item['created_at']);
          coupon['end_date'] = convertDateTime(item['expired_at']);
        } else {
          coupon['start_date'] = convertDateTime(item['start_date']);
          coupon['end_date'] = convertDateTime(item['end_date']);
        }
        if (item['discount_type'] == '1') {
          coupon['discount_type'] = false;
          coupon['discount_value'] =
              double.parse(item['discount_value'].toString())
                  .toStringAsFixed(2);
        } else {
          coupon['discount_type'] = true;
          coupon['discount_value'] =
              (double.parse(item['discount_value'].toString()) * 10)
                  .toStringAsFixed(1);
        }
        if (item['coupon_status'] == 0) {
          rawunUseCoupons.add(coupon);
        } else if (item['coupon_status'] == 1) {
          rawusedCoupons.add(coupon);
        } else {
          rawexpeiredCoupons.add(coupon);
        }
      }
      EasyLoading.dismiss();
      unUsecoupons.value = rawunUseCoupons;
      usedCoupons.value = rawusedCoupons;
      expeiredCoupon.value = rawexpeiredCoupons;
      refresh();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    } finally {
      isRequesting.value = false;
      isRequesting.refresh();
    }
  }

  void clickNavigate(int index) {
    unUsecoupons.value = [];
    usedCoupons.value = [];
    expeiredCoupon.value = [];
    if (index == 0) {
      unUse.value = true;
      used.value = false;
      expired.value = false;
    } else if (index == 1) {
      unUse.value = false;
      used.value = true;
      expired.value = false;
    } else {
      unUse.value = false;
      used.value = false;
      expired.value = true;
    }
    getMyCoupons();
  }

  @override
  void onInit() {
    super.onInit();
    getMyCoupons();
  }

  @override
  void onClose() {
    super.onClose();
    dio.close();
  }
}
