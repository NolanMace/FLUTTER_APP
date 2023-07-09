import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';

class HomePageController extends GetxController {
  RxList<dynamic> boxesOrPools = [].obs;
  RxList<dynamic> boxes = [].obs;
  RxList<dynamic> pools = [].obs;
  RxList<dynamic> swiperItems = [].obs;
  var category = 'box'.obs;
  var categoryStr = '一番赏'.obs; // 'box' or 'pool
  var navigateSelectedSizes = [0.2, 0.15, 0.15].obs;
  final dio = Dio();

  final String getAppBoxesByAppIdAndBoxType =
      AppConfig.getAppBoxesByAppIdAndBoxType;
  final String getPoolsByAppId = AppConfig.getPoolsByAppId;
  final String getAppSwiperItemsByAppId = AppConfig.getAppSwiperItemsByAppId;

  @override
  void onInit() {
    super.onInit();
    getAppSwiperItems();
    getBoxes(category.value);
  }

  @override
  void onClose() {
    super.onClose();
    dio.close();
  }

  void getBoxes(String boxType) async {
    category = boxType.obs;
    navigateSelectedSizes.value =
        boxType == 'box' ? [0.2, 0.15, 0.15] : [0.15, 0.2, 0.15];
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
    category = 'pool'.obs;
    var res = await dio.get(getPoolsByAppId, queryParameters: {
      'app_id': AppConfig.appId,
    });
    boxesOrPools.value = res.data ?? [];
    print(res.data);
    print(category.value);
  }

  void getAppSwiperItems() async {
    var res = await dio.get(getAppSwiperItemsByAppId, queryParameters: {
      'app_id': AppConfig.appId,
    });
    swiperItems.value = res.data ?? [];
    print(res.data);
  }
}
