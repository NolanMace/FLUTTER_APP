import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lzyfs_app/app_config.dart';

import 'to_login_controller.dart';

class MyConsumRecordsPageController extends ToLoginController {
  final String getMyBoxConsumRecordsUrl =
      AppConfig.getUserBoxRecordsByAppIdAndPhone;
  final String getMyDqConsumRecordsUrl =
      AppConfig.getUserDqRecordsByAppIdAndPhone;
  final String getMyPoolConsumRecordsUrl =
      AppConfig.getUserPoolRecordsByAppIdAndPhone;

  final Dio dio = Dio();

  var myConsumRecords = [].obs;

  void getMyConsumRecords(type) async {
    myConsumRecords.value = [];
    try {
      EasyLoading.show(
          status: '加载中...',
          indicator: const CircularProgressIndicator(
            color: Color.fromARGB(255, 192, 1, 1),
          ));
      isRequesting.value = true;
      isRequesting.refresh();
      final options = await AppConfig.getOptions();
      if (options == null) {
        isLogged.value = false;
        isLogged.refresh();
        EasyLoading.showError('登录过期，请重新登录');
        return;
      }
      var res;
      if (type == 'box') {
        res = await dio.get(getMyBoxConsumRecordsUrl, options: options);
      } else if (type == 'dq') {
        res = await dio.get(getMyDqConsumRecordsUrl, options: options);
      } else if (type == 'pool') {
        res = await dio.get(getMyPoolConsumRecordsUrl, options: options);
      }
      if (res.statusCode == 401) {
        EasyLoading.showError('登录过期，请重新登录');
        isLogged.value = false;
        isLogged.refresh();
        return;
      }
      if (res.statusCode != 200) {
        EasyLoading.showError('获取消费记录失败,状态码${res.statusCode},错误信息${res.data}');
        return;
      }
      isLogged.value = true;
      if (res.statusCode == 200 && res.data != null) {
        var rawDatas = res.data;
        for (var element in rawDatas) {
          element['date'] = convertDateTime(element['created_at']);
          element['amountStr'] = element['amount'].toStringAsFixed(2);
        }
        myConsumRecords.value = res.data;
      }
      EasyLoading.dismiss();
      refresh();
    } catch (e) {
      print(e);
    } finally {
      isRequesting.value = false;
      isRequesting.refresh();
    }
  }

  String convertDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

  var isBox = true.obs;
  var isDq = false.obs;
  var isPool = false.obs;

  void onTab(index) {
    if (isRequesting.value) {
      return;
    }
    isBox.value = index == 0;
    isDq.value = index == 1;
    isPool.value = index == 2;
    if (index == 0) {
      getMyConsumRecords('box');
    } else if (index == 1) {
      getMyConsumRecords('dq');
    } else if (index == 2) {
      getMyConsumRecords('pool');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getMyConsumRecords('box');
  }

  @override
  void onClose() {
    dio.close();
    super.onClose();
  }
}
