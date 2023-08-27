import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';

class ExchangeYcshipmentPageController extends GetxController {
  final dio = Dio();
  final String deComposedUrl = AppConfig.decomposeOrderItems;
  final String getAddressUrl = AppConfig.getMerchantAddress;
  final String getProductsUrl = AppConfig.getProductByShipmentOrderId;

  var address = {}.obs;
  var price = ''.obs;
  var products = [].obs;

  void getAddress() async {
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        return;
      }
      final res = await dio.get(getAddressUrl, options: options);
      if (res.statusCode != 200) {
        return;
      }
      address.value = res.data;
      address.refresh();
    } catch (e) {
      print(e);
    }
  }

  void getProducts(data) async {
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        EasyLoading.showToast('登录状态过期');
        return;
      }
      final res = await dio.post(getProductsUrl,
          options: options, data: {'json_int_arrays': data});
      if (res.statusCode != 200) {
        EasyLoading.showError('获取商品失败');
        return;
      }
      if (res.data != null) {
        products.value = res.data;
        var rprice = 0.0;
        for (var element in products) {
          rprice += double.tryParse(element['product_price'].toString()) ?? 0;
        }
        price.value = rprice.toStringAsFixed(2);
      }
      refresh();
    } catch (e) {
      EasyLoading.showError('获取商品失败${e.toString()}');
      print(e);
    }
  }

  void decompose() async {}

  @override
  void onInit() {
    var selectedIds = Get.arguments;
    getProducts(selectedIds);
    getAddress();
    super.onInit();
  }

  @override
  void onClose() {
    dio.close();
    super.onClose();
  }
}
