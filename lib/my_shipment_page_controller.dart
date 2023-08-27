import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/to_login_controller.dart';

import 'app_config.dart';

class MyShipmentPageController extends ToLoginController {
  final Dio dio = Dio();
  final String getShipmentUrl = AppConfig.getUserShipmentOrderResponses;
  final String updateShipmentUrl = AppConfig.updateAddressByShipmentOrderId;

  final ScrollController scrollController = ScrollController();
  // final ScrollController scrollController2 = ScrollController();
  // final ScrollController scrollController3 = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isRequesting.value &&
        !isGotAll) {
      getShipments(page, pagesSize, status);
    }
  }

  var page = 1;
  var pagesSize = 10;
  var status = '0';

  var isSelectedUndelivery = true.obs;
  var isSelectedWaitToDelivery = false.obs;
  var isSelectedDelivery = false.obs;
  var isSelectedUncomposed = false.obs;

  RxList shipmentOrders = [].obs;
  var lastShipmentOrders = [];

  var selectedShipmentOrderIds = [];
  void selectShipmentOrder(index) {
    var id = shipmentOrders[index]['shipment_order_id'];
    var contain = selectedShipmentOrderIds.contains(id);
    if (contain) {
      selectedShipmentOrderIds.remove(id);
    } else {
      selectedShipmentOrderIds.add(id);
    }
    shipmentOrders[index]['isSelected'] = !contain;
    shipmentOrders.refresh();
  }

  bool isGotAll = false;

  void getShipments(page, pagesSize, status) async {
    try {
      EasyLoading.show(
          status: '加载中...',
          indicator: const CircularProgressIndicator(
            color: Color.fromARGB(255, 192, 1, 1),
          ));
      isRequesting.value = true;
      isRequesting.refresh();
      var options = await AppConfig.getOptions();
      if (options == null) {
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      var res = await dio.get(getShipmentUrl,
          options: options,
          queryParameters: {
            'page': page,
            'pages_size': pagesSize,
            'status': status
          });
      if (res.statusCode == 401) {
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      if (res.statusCode != 200) {
        EasyLoading.showError('获取物流信息失败,状态码${res.statusCode},错误信息${res.data}');
        return;
      }
      isLogged.value = true;
      if (res.data == null || res.data.length == 0) {
        lastShipmentOrders.clear();
        isGotAll = true;
        return;
      }
      this.page += 1;
      isGotAll = res.data.length < pagesSize;
      lastShipmentOrders = res.data;
      if (status == '0') {
        for (var item in lastShipmentOrders) {
          item['isSelected'] = false;
        }
      }
      //拼接两个数组
      shipmentOrders.addAll(lastShipmentOrders);
      shipmentOrders.refresh();
    } catch (e) {
      print(e);
      EasyLoading.showError('获取物流信息失败${e.toString()}');
    } finally {
      isRequesting.value = false;
      isRequesting.refresh();
      EasyLoading.dismiss();
    }
  }

  //复制单号
  void copyOrderNumber(String orderNumber) {
    Clipboard.setData(ClipboardData(text: orderNumber));
    EasyLoading.showSuccess('复制成功');
  }

  //修改地址
  var isChangingAddress = false;
  void changeAddress() async {
    if (isChangingAddress) {
      return;
    }
    isChangingAddress = true;
    if (selectedShipmentOrderIds.isEmpty) {
      EasyLoading.showInfo('请选择要修改的订单');
      return;
    }
    var address =
        await Get.toNamed('/myAddressPage', arguments: 'fromCarbinet');
    if (address == null) {
      return;
    }
    try {
      EasyLoading.show(status: '修改中...');
      var options = await AppConfig.getOptions();
      if (options == null) {
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      var addressStr = address['name'] +
          ',' +
          address['phone_num'] +
          ',' +
          address['region'] +
          ',' +
          address['detail_info'];
      var res = await dio.post(updateShipmentUrl, options: options, data: {
        'json_int_arrays': selectedShipmentOrderIds,
        'json_string': addressStr
      });
      EasyLoading.dismiss();
      if (res.statusCode == 401) {
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      if (res.statusCode != 200) {
        EasyLoading.showError('修改地址失败,状态码${res.statusCode},错误信息${res.data}');
        return;
      }
      EasyLoading.showSuccess('修改地址成功');
      selectedShipmentOrderIds.clear();
      shipmentOrders.clear();
      lastShipmentOrders.clear();
      isGotAll = false;
      page = 1;
      getShipments(page, pagesSize, status);
    } catch (e) {
      print(e);
      EasyLoading.showError('修改地址失败${e.toString()}');
    } finally {
      isChangingAddress = false;
    }
  }

  void clickTab(index) {
    if (isRequesting.value) {
      return;
    }
    status = index;
    isSelectedUndelivery.value = status == '0';
    isSelectedWaitToDelivery.value = status == '2';
    isSelectedDelivery.value = status == '1';
    isSelectedUncomposed.value = status == '3';
    page = 1;
    shipmentOrders.clear();
    lastShipmentOrders.clear();
    isGotAll = false;
    getShipments(page, pagesSize, status);
  }

  void toExchangeYcShipment() async {
    if (selectedShipmentOrderIds.isEmpty) {
      EasyLoading.showToast('请选择订单！');
      return;
    }
    await Get.toNamed('exchangeYcshipmentPage',
        arguments: selectedShipmentOrderIds);
    getShipments(page, pagesSize, status);
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      scrollListener();
    });
    getShipments(page, pagesSize, status);
  }

  @override
  void onClose() {
    dio.close();
    super.onClose();
  }
}
