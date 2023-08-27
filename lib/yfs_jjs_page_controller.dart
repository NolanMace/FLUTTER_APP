import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lzyfs_app/back_home.dart';
import 'package:tobias/tobias.dart';
import 'app_config.dart';

class YfsJjsPageController extends GetxController {
  final dio = Dio();
  final String getBoxItems = AppConfig.getBoxItems;
  var instance = {}.obs;
  var productData = [];
  var records = [].obs;
  var selectedRecords = false.obs;
  var boxNumber = 0;
  final String getBLRUrl =
      AppConfig.getUserBoxLotteryRecordsByBoxIdAndBoxNumberAndAppId;
  final String getDQRUrl =
      AppConfig.getUserDqLotteryRecordsByBoxIdAndBoxNumberAndAppId;
  final String alipayUrl = AppConfig.alipayUrl;

  //支付宝插件
  Tobias tobias = Tobias();

  var dataGot = false.obs;
  var loadingText = "".obs;

  var lotteryCount = 0;
  var paymentAmount = 0.00;
  var paymentAmountStr = "0.00";
  var paymentAmountAfterDiscount = 0.00;
  var paymentAmountAfterDiscountStr = "0.00".obs;

  void setLotteryCount(value) {
    lotteryCount = value == 0 ? instance['left_num'] : value;
    computePaymentAmount();
  }

  var isCouponUsed = false.obs;
  var coupon = {}.obs;
  var usingAmount = 0.00;
  var couponDescription = "优惠券抵扣".obs;
  int userCouponId = 0;
  void useCoupon(coupon) {
    var isCouponChanged =
        this.coupon['user_coupon_id'] != coupon['user_coupon_id'];
    this.coupon.value = isCouponChanged ? coupon : {};
    couponDescription.value = isCouponChanged ? coupon['description'] : '优惠券抵扣';
    isCouponUsed.value = isCouponChanged ? true : false;
    usingAmount = isCouponChanged
        ? double.tryParse(coupon['minimum_order_amount'])!
        : 0.00;
    userCouponId = isCouponChanged ? coupon['user_coupon_id'] : 0;
    computePaymentAmount();
    isCouponUsed.refresh();
    couponDescription.refresh();
    this.coupon.refresh();
  }

  void navigateToCouponPage() async {
    dynamic selectedCoupon =
        await Get.toNamed('/useCouponPage', arguments: paymentAmountAfterXbean);
    if (selectedCoupon != null) {
      useCoupon(selectedCoupon);
    }
  }

  void toUseCouponPage() {
    Get.toNamed('/useCouponPage', arguments: paymentAmountAfterXbean);
  }

  var isXbeanUsed = false.obs;
  var xbean = 0.00.obs;
  var paymentAmountAfterXbean = 0.00;
  void useXbean() async {
    EasyLoading.show(status: 'loading...');
    await getXbean();
    EasyLoading.dismiss();
    if (xbean.value == 0.00) {
      EasyLoading.showError('暂无可用仙豆');
      isXbeanUsed.value = false;
      computePaymentAmount();
      isXbeanUsed.refresh();
      return;
    }
    isXbeanUsed.value = !isXbeanUsed.value;
    print(isXbeanUsed.value);
    computePaymentAmount();
    isXbeanUsed.refresh();
  }

  String payType = 'box';
  void computePaymentAmount() {
    paymentAmount = double.tryParse(lotteryCount.toString())! *
        instance['${payType}_price'];
    paymentAmountAfterXbean = paymentAmount;
    paymentAmountStr = paymentAmount.toStringAsFixed(2);
    var pdr = paymentAmount;
    // paymentAmountAfterDiscountStr =
    //     paymentAmountAfterDiscount.toStringAsFixed(2);
    if (isXbeanUsed.value) {
      pdr = pdr < xbean.value ? 0.00 : pdr - xbean.value;
      if (pdr < usingAmount) {
        usingAmount = 0.00;
        isCouponUsed.value = false;
        coupon.value = {};
        couponDescription.value = "优惠券抵扣>";
        userCouponId = 0;
      }
      paymentAmountAfterXbean = pdr;
    }
    if (isCouponUsed.value && coupon.value != {}) {
      if (coupon['discount_type']) {
        var discountValue = double.tryParse(coupon['discount_value'])! / 10;
        pdr = pdr * discountValue;
      } else {
        var discountValue = double.tryParse(coupon['discount_value']);
        pdr = pdr - discountValue! < 0 ? 0 : pdr - discountValue;
      }
    }
    paymentAmountAfterDiscount = pdr;
    paymentAmountAfterDiscountStr.value =
        paymentAmountAfterDiscount.toStringAsFixed(2);
    refresh();
  }

  Future getXbean() async {
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        return;
      }
      final res = await dio.get(AppConfig.getUserXbeanByAppIdAndPhone,
          options: options);
      xbean.value = double.tryParse(res.data['xbean'].toString())!;
      xbean.refresh();
    } catch (e) {
      xbean.value = 0.00;
      xbean.refresh();
      print(e);
    }
  }

  var agree = false.obs;
  void agreeProtocol() {
    agree.value = !agree.value;
    print(agree.value);
    agree.refresh();
  }

  String convertDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

  bool hasNumbers(String input) {
    RegExp regex = RegExp(r'\d');
    return regex.hasMatch(input);
  }

  //选商品页或者选记录页
  void clickSelect(index) {
    if (index == 0) {
      selectedRecords.value = false;
      getInstanceByAppIdAndPhone(instance["box_id"], instance["box_number"]);
    } else {
      selectedRecords.value = true;
      selectRecord();
    }
    selectedRecords.refresh();
    records.refresh();
  }

  void getInstanceByAppIdAndPhone(boxId, boxNumber) async {
    EasyLoading.show(
        status: 'loading...',
        indicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 192, 1, 1),
        ));
    try {
      final response = await dio.get(getBoxItems, queryParameters: {
        "box_id": boxId,
        "box_number": boxNumber,
        "app_id": AppConfig.appId
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        dataGot.value = true;
        instance.value = response.data;
        this.boxNumber = instance['box_number'];
        for (var i = 0; i < instance['box_item_counts'].length; i++) {
          var item = instance['box_item_counts'][i];
          item['index'] = i;
          if (item['product_level'] == 'last' ||
              item['product_level'] == 'first' ||
              item['product_level'] == 'gift') {
            item['oddStr'] = ' ';
            if (item['product_level'] == 'last') {
              item['detailStr'] = '非卖品，随最后一抽赠送';
            } else {
              item['detailStr'] = '非卖品，每箱售罄后随机赠送';
            }
          } else {
            double ratio =
                item['product_left_count'] / instance['total_num'] * 100;
            item['oddStr'] = '概率${ratio.toStringAsFixed(2)}%';
            item['detailStr'] = '每抽获赠一件商品，获得概率为${ratio.toStringAsFixed(2)}%';
          }
        }
        productData = instance['box_item_counts'];
        instance.refresh();
        dataGot.refresh();
        print(response.data);
        print(instance['image_url']);
      } else {
        EasyLoading.dismiss();
        print(response.data);
        Get.dialog(
            AlertDialog(
              title: const Text('提示'),
              content: const Text("网络错误"),
              actions: <Widget>[
                TextButton(
                  child: const Text('确定'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            barrierDismissible: true);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  void selectRecord() async {
    try {
      EasyLoading.show(
          status: 'loading...',
          indicator: const CircularProgressIndicator(
            color: Color.fromARGB(255, 192, 1, 1),
          ));
      final response = await dio.get(
          instance["box_type"] == "box" ? getBLRUrl : getDQRUrl,
          queryParameters: {
            "box_id": instance['box_id'],
            "box_number": boxNumber,
            "app_id": AppConfig.appId
          });
      print(response.data);
      var rrecords = response.data ?? [];
      if (rrecords != null) {
        rrecords.sort((a, b) {
          if (a['product_level'] == 'last' && b['product_level'] != 'last') {
            return -1; // a排在前面
          } else if (a['product_level'] != 'last' &&
              b['product_level'] == 'last') {
            return 1; // b排在前面
          } else if (a['product_level'] == 'first' &&
              b['product_level'] != 'first') {
            return -1; // a排在前面
          } else if (a['product_level'] != 'first' &&
              b['product_level'] == 'first') {
            return 1; // b排在前面
          } else {
            var dateA = DateTime.parse(a['created_at']);
            var dateB = DateTime.parse(b['created_at']);
            return dateB.compareTo(dateA); // 按照created_at时间排序
          }
        });
        for (var element in rrecords) {
          element['date'] = convertDateTime(element['created_at']);
          if (hasNumbers(element['product_level'])) {
            element['product_level_contains_number'] = true;
          } else {
            element['product_level_contains_number'] = false;
          }
        }
      }
      EasyLoading.dismiss();
      records.value = rrecords;
      records.refresh();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  var selectedProductIndex = 0;
  void toProductDetail(product) {
    selectedProductIndex = product['index'];
    Get.toNamed('/yfsJjsPage/productDetail', parameters: {'fromWhere': 'box'});
  }

  void back() {
    BackHome.backHome();
  }

  void dataRefresh() {
    if (selectedRecords.value) {
      selectRecord();
    } else {
      getInstanceByAppIdAndPhone(instance["box_id"], instance["box_number"]);
    }
  }

  void toChangeBoxPage() {
    Get.toNamed('/changeBoxPage', arguments: {
      'box_id': instance['box_id'],
      'box_number': instance['box_number'],
    });
  }

  void changeBox(boxNumber) async {
    if (boxNumber == instance['box_number']) {
      return;
    }
    this.boxNumber = boxNumber;
    getInstanceByAppIdAndPhone(instance["box_id"], boxNumber);
    selectRecord();
  }

  //支付方法
  var isPaying = false;
  void pay() async {
    if (isPaying) {
      return;
    }
    isPaying = true;
    if (agree.value == false) {
      EasyLoading.showToast('请先同意用户协议',
          toastPosition: EasyLoadingToastPosition.bottom,
          duration: const Duration(seconds: 2));
      isPaying = false;
      return;
    }
    EasyLoading.show(status: '支付中');
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        EasyLoading.dismiss();
        EasyLoading.showToast('请先登录',
            toastPosition: EasyLoadingToastPosition.bottom,
            duration: const Duration(seconds: 2));
        isPaying = false;
        return;
      }
      var res = await dio.post(alipayUrl, options: options, data: {
        'app_id': AppConfig.appId,
        '${payType}_id': instance['${payType}_id'],
        'box_number': instance['box_number'] ?? 0,
        'lottery_count': lotteryCount,
        'pay_type': instance['box_type'] ?? payType,
        'payment_amount': paymentAmountAfterDiscount,
        'total_amount': paymentAmount,
        'user_coupon_id': userCouponId,
        'xbean': isXbeanUsed.value ? xbean.value : 0,
      });
      print(res.data);
      if (isXbeanUsed.value && paymentAmountAfterDiscount == 0) {
        EasyLoading.dismiss();
        Get.back();
        Get.toNamed('resultPage', parameters: {
          'pay_type': instance['box_type'] ?? payType,
          'out_trade_no': res.data['out_trade_no'].toString(),
        });
        isPaying = false;
        return;
      }
      await tobias.pay(res.data['payParam'].toString());
      EasyLoading.dismiss();
      Get.back();
      Get.toNamed('resultPage', parameters: {
        'pay_type': instance['box_type'] ?? payType,
        'out_trade_no': res.data['outTradeNo'].toString(),
      });
      isPaying = false;
    } catch (e) {
      isPaying = false;
      EasyLoading.dismiss();
      EasyLoading.showToast('支付失败');
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getInstanceByAppIdAndPhone(int.tryParse(Get.parameters['box_id'] ?? '0'),
        int.tryParse(Get.parameters['box_number'] ?? '0'));
    getXbean();
  }

  @override
  void onClose() {
    super.onClose();
    dio.close();
  }
}
