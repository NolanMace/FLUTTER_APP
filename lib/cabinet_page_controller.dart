import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/jverify_controller.dart';
import 'package:lzyfs_app/to_login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';

class CabinetPageController extends ToLoginController {
  final dio = Dio();
  final String getMyCabinetItemsByAppIdAndPhone =
      AppConfig.getMyCabinetItemsByAppIdAndPhone;
  final JverifyController jverifyController = Get.find();
  RxBool yfsselected = true.obs;
  RxBool jjsselected = false.obs;
  RxBool wxsselected = false.obs;
  int selectedIndex = 0;
  List<int> selectedCabinetItemIds = [];

  RxString shipmentOrderNote = "".obs;

  RxBool selectedAddress = true.obs;
  RxString address = 'sss'.obs;
  double postage = 0;
  RxList<dynamic> boxProducts = [].obs;
  RxList<dynamic> dqProducts = [].obs;
  RxList<dynamic> poolProducts = [].obs;
  RxList<dynamic> showProducts = [].obs;
  RxList<dynamic> selectedBoxProducts = [].obs;
  RxList<dynamic> selectedDqProducts = [].obs;
  RxList<dynamic> selectedPoolProducts = [].obs;

  //点击选择
  void onItemTapped(index) {
    if (!showProducts[index]['selected'] &&
        !selectedCabinetItemIds
            .contains(showProducts[index]["cabinet_item_id"])) {
      selectedCabinetItemIds.add(showProducts[index]["cabinet_item_id"]);
      showProducts[index]['selected'] = true;
    } else if (showProducts[index]['selected'] &&
        selectedCabinetItemIds
            .contains(showProducts[index]["cabinet_item_id"])) {
      selectedCabinetItemIds.remove(showProducts[index]["cabinet_item_id"]);
      showProducts[index]['selected'] = false;
    }
    showProducts.refresh();
    print(selectedCabinetItemIds);
  }

  RxBool selectedAll = false.obs;

  //点击全选
  void selectAll() {
    selectedAll.value = !selectedAll.value;
    for (var item in showProducts) {
      item["selected"] = selectedAll.value;
      if (selectedAll.value &&
          !selectedCabinetItemIds.contains(item["cabinet_item_id"])) {
        selectedCabinetItemIds.add(item["cabinet_item_id"]);
      } else if (!selectedAll.value &&
          selectedCabinetItemIds.contains(item["cabinet_item_id"])) {
        selectedCabinetItemIds.remove(item["cabinet_item_id"]);
      }
    }
    showProducts.refresh();
    print(selectedCabinetItemIds);
  }

  //更新展示的产品
  updateShowProducts() {
    if (yfsselected.value) {
      if (selectedIndex == 0) {
        showProducts.value = boxProducts;
      } else if (selectedIndex == 1) {
        showProducts.value =
            boxProducts.where((element) => element['in_stock'] == '1').toList();
      } else if (selectedIndex == 2) {
        showProducts.value =
            boxProducts.where((element) => element['in_stock'] == '2').toList();
      }
    } else if (jjsselected.value) {
      if (selectedIndex == 0) {
        showProducts.value = dqProducts;
      } else if (selectedIndex == 1) {
        showProducts.value =
            dqProducts.where((element) => element['in_stock'] == '1').toList();
      } else if (selectedIndex == 2) {
        showProducts.value =
            dqProducts.where((element) => element['in_stock'] == '2').toList();
      }
    } else if (wxsselected.value) {
      if (selectedIndex == 0) {
        showProducts.value = poolProducts;
      } else if (selectedIndex == 1) {
        showProducts.value = poolProducts
            .where((element) => element['in_stock'] == '1')
            .toList();
      } else if (selectedIndex == 2) {
        showProducts.value = poolProducts
            .where((element) => element['in_stock'] == '2')
            .toList();
      }
    }
  }

  //一级导航点击
  selectFirstNavigate(type) {
    yfsselected.value = type == 'box';
    jjsselected.value = type == 'dq';
    wxsselected.value = type == 'pool';
    updateShowProducts();
    print(type);
  }

  selectSecondNavigate(index) {
    selectedIndex = index;
    updateShowProducts();
  }

  //点击发货统计选择的商品
  countSelectedShippingProduct() {
    List<dynamic> selectedBoxLotteryRecords = [];
    List<dynamic> selectedDqLotteryRecords = [];
    List<dynamic> selectedPoolLotteryRecords = [];
    for (var i = 0; i < boxProducts.length; i++) {
      //1为现货，2为预售
      if (boxProducts[i]["selected"] && boxProducts[i]["in_stock"] == "2") {
        selectedCabinetItemIds.remove(boxProducts[i]["cabinet_item_id"]);
        boxProducts[i]["selected"] = false;
      } else if (boxProducts[i]["selected"] &&
          boxProducts[i]["in_stock"] == "1") {
        selectedBoxLotteryRecords.add(boxProducts[i]);
      }
    }
    for (var i = 0; i < dqProducts.length; i++) {
      if (dqProducts[i]["selected"] && dqProducts[i]["in_stock"] == "2") {
        selectedCabinetItemIds.remove(dqProducts[i]["cabinet_item_id"]);
        dqProducts[i]["selected"] = false;
      } else if (dqProducts[i]["selected"] &&
          dqProducts[i]["in_stock"] == "1") {
        selectedDqLotteryRecords.add(dqProducts[i]);
      }
    }
    for (var i = 0; i < poolProducts.length; i++) {
      if (poolProducts[i]["selected"] && poolProducts[i]["in_stock"] == "2") {
        selectedCabinetItemIds.remove(poolProducts[i]["cabinet_item_id"]);
        poolProducts[i]["selected"] = false;
      } else if (poolProducts[i]["selected"] &&
          poolProducts[i]["in_stock"] == "1") {
        selectedPoolLotteryRecords.add(poolProducts[i]);
      }
    }
    List<int> countedBoxProductIds = [];
    List<int> countedDqProductIds = [];
    List<int> countedPoolProductIds = [];
    List<dynamic> countedBoxProducts = [];
    List<dynamic> countedDqProducts = [];
    List<dynamic> countedPoolProducts = [];
    for (var i = 0; i < selectedBoxLotteryRecords.length; i++) {
      if (!countedBoxProductIds
          .contains(selectedBoxLotteryRecords[i]["product_id"])) {
        countedBoxProductIds.add(selectedBoxLotteryRecords[i]["product_id"]);
        selectedBoxLotteryRecords[i]["count"] = 1;
        countedBoxProducts.add(selectedBoxLotteryRecords[i]);
      } else {
        for (var j = 0; j < countedBoxProducts.length; j++) {
          if (countedBoxProducts[j]["product_id"] ==
              selectedBoxLotteryRecords[i]["product_id"]) {
            countedBoxProducts[j]["count"] += 1;
          }
        }
      }
    }
    for (var i = 0; i < selectedDqLotteryRecords.length; i++) {
      if (!countedDqProductIds
          .contains(selectedDqLotteryRecords[i]["product_id"])) {
        countedDqProductIds.add(selectedDqLotteryRecords[i]["product_id"]);
        selectedDqLotteryRecords[i]["count"] = 1;
        countedDqProducts.add(selectedDqLotteryRecords[i]);
      } else {
        for (var j = 0; j < countedDqProducts.length; j++) {
          if (countedDqProducts[j]["product_id"] ==
              selectedDqLotteryRecords[i]["product_id"]) {
            countedDqProducts[j]["count"] += 1;
          }
        }
      }
    }
    for (var i = 0; i < selectedPoolLotteryRecords.length; i++) {
      if (!countedPoolProductIds
          .contains(selectedPoolLotteryRecords[i]["product_id"])) {
        countedPoolProductIds.add(selectedPoolLotteryRecords[i]["product_id"]);
        selectedPoolLotteryRecords[i]["count"] = 1;
        countedPoolProducts.add(selectedPoolLotteryRecords[i]);
      } else {
        for (var j = 0; j < countedPoolProducts.length; j++) {
          if (countedPoolProducts[j]["product_id"] ==
              selectedPoolLotteryRecords[i]["product_id"]) {
            countedPoolProducts[j]["count"] += 1;
          }
        }
      }
    }
    //满5件包邮
    postage = selectedCabinetItemIds.length > 5 ? 0 : 10;
    selectedBoxProducts.value = countedBoxProducts;
    selectedDqProducts.value = countedDqProducts;
    selectedPoolProducts.value = countedPoolProducts;
  }

  void getMyProducts() async {
    print(isLogged.value);
    final prefs = await SharedPreferences.getInstance();
    try {
      isRequesting.value = true;
      isRequesting.refresh();
      //获取名为“token”的值，如果该键不存在，则返回默认值null
      final token = prefs.getString('token');
      if (token == null) {
        return;
      }
      EasyLoading.show(
          status: '加载中...',
          indicator: const CircularProgressIndicator(
            color: Color.fromARGB(255, 192, 1, 1),
          ));
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var res =
          await dio.get(getMyCabinetItemsByAppIdAndPhone, options: options);
      if (res.statusCode == 200) {
        isLogged.value = true;
        EasyLoading.dismiss();
        print(res.data);
        boxProducts.value = res.data['box_products'];
        dqProducts.value = res.data['dq_products'];
        poolProducts.value = res.data['pool_products'];
        for (var element in boxProducts) {
          element['selected'] = false;
        }
        for (var element in dqProducts) {
          element['selected'] = false;
        }
        for (var element in poolProducts) {
          element['selected'] = false;
        }
        updateShowProducts();
      } else {
        EasyLoading.dismiss();
        prefs.remove('token');
        print("111");
        isLogged.value = false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      prefs.remove('token');
      isLogged.value = false;
    } finally {
      isRequesting.value = false;
      isRequesting.refresh();
    }
  }

  void setShipmentOrderNote(String notes) {
    shipmentOrderNote.value = notes;
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   dio.close();
  // }

  @override
  void onInit() {
    super.onInit();
    getMyProducts();
  }

  @override
  void refresh() {
    super.refresh();
    selectedAll.value = false;
    selectedCabinetItemIds.clear();
    selectedBoxProducts.clear();
    selectedDqProducts.clear();
    selectedPoolProducts.clear();
    showProducts.clear();
    boxProducts.clear();
    dqProducts.clear();
    poolProducts.clear();
    getMyProducts();
  }
}
