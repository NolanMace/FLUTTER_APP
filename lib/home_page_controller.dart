import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';

class HomePageController extends GetxController {
  RxList<dynamic> boxesOrPools = [].obs;
  RxList<dynamic> boxes = [].obs;
  RxList<dynamic> pools = [].obs;
  RxList<dynamic> winbars = [].obs;
  RxList<dynamic> swiperItems = [].obs;
  var swiperCurrentIndex = 0.obs;
  var category = 'box'.obs;
  var categoryStr = '一番赏'.obs; // 'box' or 'pool
  var navigateSelectedSizes = [0.2, 0.15, 0.15].obs;
  final dio = Dio();

  final String getAppBoxesByAppIdAndBoxType =
      AppConfig.getAppBoxesByAppIdAndBoxType;
  final String getPoolsByAppId = AppConfig.getPoolsByAppId;
  final String getAppSwiperItemsByAppId = AppConfig.getAppSwiperItemsByAppId;
  final String getWindowBarByAppId = AppConfig.getWindowBarByAppId;

  @override
  void onInit() {
    super.onInit();
    getAppSwiperItems();
    getBoxes(category.value);
    getWindowBar();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   dio.close();
  // }

  void onSwiperChange(index) {
    swiperCurrentIndex.value = index;
  }

  void getBoxes(String boxType) async {
    category.value = boxType;
    category.refresh();
    boxesOrPools.value = [];
    boxesOrPools.refresh();
    categoryStr = boxType == 'box' ? '一番赏'.obs : '竞技赏'.obs;
    var res = await dio.get(getAppBoxesByAppIdAndBoxType, queryParameters: {
      'app_id': AppConfig.appId,
      'box_type': boxType,
    });
    boxesOrPools.value = res.data ?? [];
    print(res.data);
    print(category.value);
  }

  void getPools() async {
    navigateSelectedSizes.value = [0.15, 0.15, 0.2];
    categoryStr = '无限赏'.obs;
    category.value = 'pool';
    boxesOrPools.value = [];
    boxesOrPools.refresh();
    category.refresh();
    try {
      var res = await dio.get(getPoolsByAppId, queryParameters: {
        'app_id': AppConfig.appId,
      });
      print(res.data);
      boxesOrPools.value = res.data ?? [];
      boxesOrPools.refresh();
    } catch (e) {
      print(e);
    }
    print(category.value);
  }

  void getAppSwiperItems() async {
    try {
      var res = await dio.get(getAppSwiperItemsByAppId, queryParameters: {
        'app_id': AppConfig.appId,
      });
      swiperItems.value = res.data ?? [];
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  void getWindowBar() async {
    try {
      final response = await dio.get(getWindowBarByAppId, queryParameters: {
        "app_id": AppConfig.appId,
      });
      if (response.statusCode == 200) {
        winbars.value = response.data ?? [];
        winbars.refresh();
        print(response.data);
      } else {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  void toWinbarDetail(winbar) {
    Get.toNamed('/categoryPage', arguments: winbar);
  }

  void toYfsJjsPage(box) {
    if (box['box_type'] == 'box' || box['box_type'] == 'dq') {
      Get.toNamed('/yfsJjsPage?box_id=${box['box_id']}&box_number=0');
    }
  }

  void toWxsPage(pool) {
    Get.toNamed('/wxsPage', parameters: {
      'pool_id': pool['pool_id'].toString(),
    });
  }
}
