import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'app_config.dart';

class AddAddressPageController extends GetxController {
  final Dio dio = Dio();
  final String addAddressUrl = AppConfig.createAddress;
  final String updateAddressUrl = AppConfig.updateAddress;

  int autoId = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController detailInfoController = TextEditingController();
  final TextEditingController regionController = TextEditingController();

  var initProvince = '四川省', initCity = '成都市', initTown = '双流区';

  void onConfirmRegion(p, c, t) {
    initProvince = p;
    initCity = c;
    initTown = t;
    regionController.text = '$p $c $t';
  }

  Widget changeMenuButtonToCN(context, editableTextState) {
    final List<ContextMenuButtonItem> buttonItems =
        editableTextState.contextMenuButtonItems;
    //循环，把英文换成中文
    List items = [
      {'type': ContextMenuButtonType.copy, 'text': '复制'},
      {'type': ContextMenuButtonType.paste, 'text': '粘贴'},
      {'type': ContextMenuButtonType.cut, 'text': '剪切'},
      {'type': ContextMenuButtonType.selectAll, 'text': '全选'}
    ];
    for (var element in items) {
      var index = buttonItems.indexWhere((ContextMenuButtonItem buttonItem) {
        return buttonItem.type == element['type'];
      });
      if (index == -1) {
        continue;
      }
      buttonItems.removeAt(index);
      buttonItems.add(ContextMenuButtonItem(
        onPressed: () async {
          switch (element['text']) {
            case '复制':
              return editableTextState
                  .copySelection(SelectionChangedCause.toolbar);
            case '粘贴':
              return editableTextState.pasteText(SelectionChangedCause.toolbar);
            case '剪切':
              return editableTextState
                  .cutSelection(SelectionChangedCause.toolbar);
            case '全选':
              return editableTextState.selectAll(SelectionChangedCause.toolbar);
            default:
              return editableTextState
                  .copySelection(SelectionChangedCause.toolbar);
          }
        },
        label: element['text'],
      ));
    }
    // buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
    //   return buttonItem.type == ContextMenuButtonType.cut;
    // });
    // //换成中文的剪切
    // buttonItems.add(ContextMenuButtonItem(
    //   onPressed: () {
    //     editableTextState
    //         .cutSelection(SelectionChangedCause.toolbar);
    //   },
    //   label: '剪切',
    // ));
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  }

  void onSave() async {
    if (nameController.text.isEmpty) {
      EasyLoading.showToast('请输入收货人姓名');
      return;
    }
    if (phoneController.text.isEmpty) {
      EasyLoading.showToast('请输入收货人手机号');
      return;
    }
    if (detailInfoController.text.isEmpty) {
      EasyLoading.showToast('请输入详细地址');
      return;
    }
    EasyLoading.show(status: '保存中...');
    var data = {
      'auto_id': autoId,
      'user_id': 0,
      'app_id': AppConfig.appId,
      'name': nameController.text,
      'phone_num': phoneController.text,
      'region': '$initProvince,$initCity,$initTown',
      'detail_info': detailInfoController.text,
    };
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        EasyLoading.dismiss();
        EasyLoading.showToast('登录已过期，请重新登录');
        return;
      }
      var res;
      if (data['auto_id'] == 0) {
        res = await dio.post(addAddressUrl, options: options, data: data);
      } else {
        res = await dio.post(updateAddressUrl, options: options, data: data);
      }
      if (res.statusCode == 401) {
        EasyLoading.dismiss();
        EasyLoading.showToast('登录已过期，请重新登录');
        return;
      }
      if (res.statusCode != 200) {
        EasyLoading.dismiss();
        EasyLoading.showToast('保存失败${res.data}');
        return;
      }
      EasyLoading.dismiss();
      EasyLoading.showToast('保存成功');
      Get.back(result: true);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast('保存失败$e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      autoId = Get.arguments['auto_id'] ?? 0;
      nameController.text = Get.arguments['name'];
      phoneController.text = Get.arguments['phone_num'];
      detailInfoController.text = Get.arguments['detail_info'];
      var region = Get.arguments['region'].split(',');
      initProvince = region[0];
      initCity = region[1];
      initTown = region[2];
    }
    regionController.text = '$initProvince $initCity $initTown';
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    detailInfoController.dispose();
    dio.close();
    super.onClose();
  }
}
