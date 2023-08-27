import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lzyfs_app/app_config.dart';

class UseCouponPageController extends GetxController {
  final dio = Dio();
  final String getMyNotUsedCouponsUrl = AppConfig.getUserCouponByAppIdAndPhone;

  var coupons = [].obs;
  var usingAmount = 0.0;

  String convertDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

  void getMyNotUsedCoupons() async {
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        EasyLoading.showError('登录过期，请重新登录');
        return;
      }
      final response = await Dio().get(
        getMyNotUsedCouponsUrl,
        options: options,
      );
      if (response.statusCode == 401) {
        //处理登录逻辑
        EasyLoading.showError('登录过期，请重新登录');
        return;
      }
      if (response.statusCode != 200) {
        EasyLoading.showError('获取优惠券失败');
        return;
      }
      final rawData = response.data;
      final List<Map<String, dynamic>> newCoupons = [];
      if (rawData == null) {
        return;
      }
      print(response.data);
      for (var item in rawData) {
        final coupon = {
          'user_coupon_id': item['user_coupon_id'],
          'minimum_order_amount': item['minimum_order_amount'] == null ||
                  item['minimum_order_amount'] == 0
              ? '0.00'
              : double.parse(item['minimum_order_amount'].toString())
                  .toStringAsFixed(2),
          'description': item['description'],
          'isAvailable':
              double.parse(item['minimum_order_amount'].toString()) <=
                  usingAmount,
          'coupon_status': item['coupon_status'],
          'coupon_name': item['coupon_name'],
        };
        if (coupon['coupon_status'] != 0) {
          continue;
        }
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

        if (coupon['isAvailable']) {
          newCoupons.insert(0, coupon);
        } else {
          newCoupons.add(coupon);
        }
      }
      coupons.value = newCoupons;
      print(coupons);
      coupons.refresh();
    } catch (e) {
      print('Error: $e');
    }
  }

  selectCoupon(int index) {
    // Get.toNamed('/myCouponPage');
    // return;
    if (!coupons[index]['isAvailable']) {
      EasyLoading.showError('该优惠券不可用');
      return;
    }
    Get.back(result: coupons[index]);
    //让下一个页面调用useCoupon方法
  }

  @override
  void onInit() {
    super.onInit();
    usingAmount = Get.arguments;
    getMyNotUsedCoupons();
  }

  @override
  void onClose() {
    super.onClose();
    dio.close();
  }
}
