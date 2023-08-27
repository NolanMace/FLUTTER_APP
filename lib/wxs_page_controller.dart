import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/yfs_jjs_page_controller.dart';

class WxsPageController extends YfsJjsPageController {
  List<Map<String, dynamic>> result = [];
  final String getPoolInstanceUrl =
      AppConfig.getPoolAndPoolItemSetsByPoolIdAndAppId;
  final String getRecordUrl =
      AppConfig.getUserPoolLotteryRecordsByPoolIdAndAppId;
  final levelOrder = [
    "SP",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  var poolRecords = [].obs;

  @override
  void setLotteryCount(value) {
    lotteryCount = value;
    computePaymentAmount();
  }

  @override
  void getInstanceByAppIdAndPhone(boxId, boxNumber) {
    return;
  }

  void getPoolInstanceByAppIdAndPhone(int poolId) async {
    EasyLoading.show(
        status: 'loading...',
        indicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 192, 1, 1),
        ));
    try {
      var response = await dio.get(getPoolInstanceUrl, queryParameters: {
        'app_id': AppConfig.appId,
        'pool_id': poolId,
      });

      if (response.statusCode == 200) {
        instance.value = response.data ?? {};
        productData = response.data['pool_item_sets'] ?? [];
        if (productData.isEmpty) {
          EasyLoading.dismiss();
          return;
        }
        productData.sort((a, b) {
          final aIndex = levelOrder.indexOf(a['product_level']);
          final bIndex = levelOrder.indexOf(b['product_level']);
          return aIndex - bIndex;
        });
      }
      productData.asMap().forEach((index, item) {
        item['probability_str'] =
            (item['probability'] * 100).toStringAsFixed(3);
        item['index'] = index;
        item['detailStr'] =
            '参考价${item['product_price'].toStringAsFixed(2)}元,获得概率约为${item['probability_str']}%';

        final existingIndex = result
            .indexWhere((el) => el['product_level'] == item['product_level']);
        if (existingIndex == -1) {
          Map<String, dynamic> newItem = {
            'product_level': item['product_level'],
            'probability': item['probability'],
            'probability_str': (item['probability'] * 100).toStringAsFixed(3),
            'products': [
              {
                'index': item['index'],
                'product_name': item['product_name'],
                'product_price': item['product_price'].toStringAsFixed(2),
                'product_image_url': item['product_image_url'],
                'probability': item['probability'],
              },
            ],
          };
          result.add(newItem);
        } else {
          result[existingIndex]['products'].add({
            'index': item['index'],
            'product_name': item['product_name'],
            'product_image_url': item['product_image_url'],
            'product_price': item['product_price'].toStringAsFixed(2),
            'probability': item['probability'],
          });
          result[existingIndex]['probability'] += item['probability'];
          result[existingIndex]['probability_str'] =
              (result[existingIndex]['probability'] * 100).toStringAsFixed(3);
        }
      });
      dataGot.value = true;
      dataGot.refresh();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('网络错误');
      print(e);
    }
  }

  @override
  void selectRecord() async {
    EasyLoading.show(
        status: 'loading...',
        indicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 192, 1, 1),
        ));
    try {
      var res = await dio.get(getRecordUrl, queryParameters: {
        'app_id': AppConfig.appId,
        'pool_id': instance['pool_id'],
      });
      poolRecords.value = [];
      List rawRecords = res.data ?? [];
      print(rawRecords);
      if (rawRecords.isNotEmpty) {
        rawRecords.sort((a, b) {
          final aIndex = levelOrder.indexOf(a['product_level']);
          final bIndex = levelOrder.indexOf(b['product_level']);
          if (aIndex != bIndex) {
            return aIndex - bIndex;
          } else {
            var dateA = DateTime.parse(a['created_at']);
            var dateB = DateTime.parse(b['created_at']);
            return dateB.compareTo(dateA);
          }
        });

        for (var element in rawRecords) {
          element['date'] = convertDateTime(element['created_at']);
        }
      }
      //把排好序的记录数组按等级分组
      for (var i = 0; i < rawRecords.length; i++) {
        if (i == 0 ||
            rawRecords[i]['product_level'] !=
                rawRecords[i - 1]['product_level']) {
          var newItem = {
            'product_level': rawRecords[i]['product_level'],
            'isUnfold': false,
            'records': [rawRecords[i]],
          };
          poolRecords.add(newItem);
        } else {
          poolRecords.last['records'].add(rawRecords[i]);
        }
      }
      poolRecords.refresh();
      print(poolRecords);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('网络错误');
      print(e);
    }
  }

  void toUnfold(index) {
    print('index: $index');
    poolRecords[index]['isUnfold'] = !poolRecords[index]['isUnfold'];
    poolRecords.refresh();
  }

  @override
  void clickSelect(index) {
    if (index == 0) {
      selectedRecords.value = false;
      selectedRecords.refresh();
      getPoolInstanceByAppIdAndPhone(instance['pool_id']);
    } else {
      selectedRecords.value = true;
      selectedRecords.refresh();
      selectRecord();
    }
  }

  @override
  void toProductDetail(product) {
    selectedProductIndex = product['index'];
    Get.toNamed('/wxsPage/productDetail', parameters: {'fromWhere': 'pool'});
  }

  @override
  void dataRefresh() {
    selectRecord();
  }

  @override
  void onInit() {
    super.onInit();
    payType = 'pool'; //支付使用
    getPoolInstanceByAppIdAndPhone(int.tryParse(Get.parameters['pool_id']!)!);
  }
}
