import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';

class CategoryPageController extends GetxController {
  var dio = Dio();
  final String getDisplaysUrl = AppConfig.getWindowBarBoxByAppId;

  var windowName = ''.obs;
  var topUrl = ''.obs;
  var coverUrl = ''.obs;

  var boxes = [].obs;
  var dqs = [].obs;
  var pools = [].obs;
  var isShowBox = true.obs;
  var isShowDq = false.obs;
  var isShowPool = false.obs;
  var categoryStr = '一番赏'.obs;

  void getDisplays() async {
    try {
      var res = await dio.get(getDisplaysUrl, queryParameters: {
        'app_id': AppConfig.appId,
        'window_name': windowName.value,
        'window_type': 'all'
      });
      print(res.data);
      if (res.data == null) {
        return;
      }
      var displays = res.data;
      var rboxes = [];
      var rdqs = [];
      var rpools = [];
      for (var item in displays) {
        item['priceStr'] = double.tryParse(item['window_bar_price'].toString())!
            .toStringAsFixed(2);
        if (item['window_bar_type'] == 'box') {
          rboxes.add(item);
        } else if (item['window_bar_type'] == 'dq') {
          rdqs.add(item);
        } else if (item['window_bar_type'] == 'pool') {
          rpools.add(item);
        }
      }
      boxes.value = rboxes;
      dqs.value = rdqs;
      pools.value = rpools;
      refresh();
    } catch (e) {
      EasyLoading.showError('网络错误${e.toString()}}');
    }
  }

  void switchTab(value) {
    isShowBox.value = value == 0;
    isShowDq.value = value == 1;
    isShowPool.value = value == 2;
    switch (value) {
      case 0:
        categoryStr.value = '一番赏';
        break;
      case 1:
        categoryStr.value = '竞技赏';
        break;
      case 2:
        categoryStr.value = '无限赏';
        break;
      default:
    }
    refresh();
  }

  void toYfsJjsPage(box) {
    if (box['window_bar_type'] == 'box' || box['window_bar_type'] == 'dq') {
      Get.toNamed('/yfsJjsPage?box_id=${box['window_bar_id']}&box_number=0');
    }
  }

  void toWxsPage(pool) {
    Get.toNamed('/wxsPage', parameters: {
      'pool_id': pool['window_bar_id'].toString(),
    });
  }

  @override
  void onInit() {
    windowName.value = Get.arguments['window_name'];
    topUrl.value = Get.arguments['top_url'];
    coverUrl.value = Get.arguments['cover_url'];
    getDisplays();
    super.onInit();
  }

  @override
  void onClose() {
    dio.close();
    super.onClose();
  }
}
