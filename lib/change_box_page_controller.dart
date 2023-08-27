import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';

import 'yfs_jjs_page_controller.dart';

class ChangeBoxPageController extends GetxController {
  final String getBoxInstancesUrl = AppConfig.getBoxInstances;
  final Dio dio = Dio();
  var boxId = 0;
  var boxNumber = 0;
  final double itemExtent = 80;
  ScrollController scrollController = ScrollController();
  var segmentation = [].obs;
  var boxes = [];
  var filteredBoxes = [].obs;
  final int dividendLength = 2;

  void onRangeButtonClick(int index) {
    final int selectedIndex =
        segmentation.indexWhere((item) => item['isSelected'] == true);

    if (selectedIndex >= 0) {
      segmentation[selectedIndex]['isSelected'] = false;
    }

    segmentation[index]['isSelected'] = true;
    segmentation.refresh();
    selectRangeBoxes(segmentation[index]['start'], segmentation[index]['end']);
  }

  void selectRangeBoxes(int start, int end) {
    filteredBoxes.value = boxes.where((box) {
      final int boxNumber = box['box_number'];
      return boxNumber >= start && boxNumber <= end;
    }).toList();
    filteredBoxes.refresh();
  }

  void getBoxInstances() async {
    EasyLoading.show(status: '加载中...');
    try {
      var response = await dio.get(getBoxInstancesUrl, queryParameters: {
        'box_id': boxId,
        'app_id': AppConfig.appId,
      });
      if (response.statusCode == 200) {
        boxes = response.data;
        for (int i = 0; i < (boxes.length / dividendLength).ceil(); i++) {
          final Map<String, dynamic> rawRange = {
            'start': i * dividendLength + 1,
            'end': (i + 1) * dividendLength,
            'isSelected': false,
          };
          segmentation.add(rawRange);
        }
        segmentation.refresh();
        var index = (boxNumber / dividendLength).ceil() - 1;
        setInitialScrollOffset(index);
        onRangeButtonClick(index);
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  void selectBox(int index) {
    var yfsJjsPageController = Get.find<YfsJjsPageController>();
    var boxNumber = filteredBoxes[index]['box_number'];
    yfsJjsPageController.changeBox(boxNumber);
    Get.back();
  }

  void setInitialScrollOffset(int selectedIndex) {
    // 确定初始滚动偏移量，根据你的列表项高度来计算
    double initialOffset = itemExtent * selectedIndex;
    scrollController.jumpTo(initialOffset);
  }

  @override
  void onInit() {
    super.onInit();
    boxId = Get.arguments['box_id'];
    boxNumber = Get.arguments['box_number'];
    getBoxInstances();
  }

  @override
  void onClose() {
    super.onClose();
    dio.close();
  }
}
