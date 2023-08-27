import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String apiBaseUrl = 'https://www.yfsmax.top/api/';
  static const String appId = '1';
  static const String loginUrl = '${apiBaseUrl}AppAuthLogin';
  static const String appSendSMSCode = '${apiBaseUrl}AppSendSMSCode';
  static const String smsLoginUrl = '${apiBaseUrl}AppSmsLogin';
  static const String alipayUrl = '${apiBaseUrl}AlipayTradeAppPay';

  static const String getBox = '${apiBaseUrl}GetBox';
  static const String getAppBoxesByAppIdAndBoxType =
      '${apiBaseUrl}GetAppBoxesByAppIdAndBoxType';
  static const String getPoolsByAppId = '${apiBaseUrl}GetPoolsByAppId';
  static const String getBoxItems =
      '${apiBaseUrl}GetBoxInstanceByAppIdAndBoxIdAndBoxNumber';
  static const String getBoxInstances =
      '${apiBaseUrl}GetBoxInstanceByAppIdAndBoxId';
  static const String getPoolAndPoolItemSetsByPoolIdAndAppId =
      '${apiBaseUrl}GetPoolAndPoolItemSetsByPoolIdAndAppId';
  static const String getUserXbeanByAppIdAndPhone =
      '${apiBaseUrl}GetUserXbeanByAppIdAndPhone';

  //抽奖结果接口
  static const String getUserBoxLotteryRecordsByOutTradeNo =
      '${apiBaseUrl}GetUserBoxLotteryRecordsByOutTradeNo';
  static const String getUserDqLotteryRecordsByOutTradeNo =
      '${apiBaseUrl}GetUserDqLotteryRecordsByOutTradeNo';
  static const String getUserPoolLotteryRecordsByOutTradeNo =
      '${apiBaseUrl}GetUserPoolLotteryRecordsByOutTradeNo';

  static const String getMyCabinetItemsByAppIdAndPhone =
      '${apiBaseUrl}GetMyCabinetItemsByAppIdAndPhone';
  static const String createWxUserShipmentOrder =
      '${apiBaseUrl}createWxUserShipmentOrder';
  static const String getUserShipmentOrderResponses =
      '${apiBaseUrl}GetUserShipmentOrderResponses';
  static const String decomposeOrderItems = '${apiBaseUrl}DecomposeOrderItems';
  static const String getUserBoxLotteryRecordsByBoxIdAndBoxNumberAndAppId =
      '${apiBaseUrl}GetUserBoxLotteryRecordsByBoxIdAndBoxNumberAndAppId';
  static const String getUserDqLotteryRecordsByBoxIdAndBoxNumberAndAppId =
      '${apiBaseUrl}GetUserDqLotteryRecordsByBoxIdAndBoxNumberAndAppId';
  static const String getUserPoolLotteryRecordsByPoolIdAndAppId =
      '${apiBaseUrl}GetUserPoolLotteryRecordsByPoolIdAndAppId';
  static const String getAddressesByUserId =
      '${apiBaseUrl}GetAddressesByUserId';
  static const String createAddress = '${apiBaseUrl}CreateAddress';
  static const String updateAddress = '${apiBaseUrl}UpdateAddress';
  static const String deleteAddress = '${apiBaseUrl}DeleteAddress';
  static const String deleteAddresses = '${apiBaseUrl}DeleteAddresses';
  static const String updateAddressByShipmentOrderId =
      '${apiBaseUrl}UpdateAddressByShipmentOrderId';
  static const String getUserBoxRecordsByAppIdAndPhone =
      '${apiBaseUrl}GetUserBoxRecordsByAppIdAndPhone';
  static const String getUserPoolRecordsByAppIdAndPhone =
      '${apiBaseUrl}GetUserPoolRecordsByAppIdAndPhone';
  static const String getUserDqRecordsByAppIdAndPhone =
      '${apiBaseUrl}GetUserDqRecordsByAppIdAndPhone';
  static const String getUserAgreementByAppId =
      '${apiBaseUrl}GetUserAgreementByAppId';
  static const String getAppHomePopupByAppId =
      '${apiBaseUrl}GetAppHomePopupByAppId';
  static const String getUserCouponByAppIdAndPhone =
      '${apiBaseUrl}GetUserCouponByAppIdAndPhone';
  static const String updateAvatarUrlByPhoneAndAppId =
      '${apiBaseUrl}UpdateAvatarUrlByPhoneAndAppId';
  static const String updateNicknameByPhoneAndAppId =
      '${apiBaseUrl}UpdateNicknameByPhoneAndAppId';
  static const String getUserAvatarAndNicknameByPhoneAndAppId =
      '${apiBaseUrl}GetUserAvatarAndNicknameByPhoneAndAppId';
  static const String getAppSwiperItemsByAppId =
      '${apiBaseUrl}GetAppSwiperItemsByAppId';
  static const String getWindowBarByAppId = '${apiBaseUrl}GetWindowBarByAppId';
  static const String getMerchantAddress = '${apiBaseUrl}GetMerchantAddress';
  static const String getProductByShipmentOrderId =
      '${apiBaseUrl}GetProductByShipmentOrderId';
  static const String getWindowBarBoxByAppId =
      '${apiBaseUrl}GetWindowBarBoxByAppId';

  static Future<Options?> getOptions() async {
    final prefs = await SharedPreferences.getInstance();
    //获取名为“token”的值，如果该键不存在，则返回默认值null
    final token = prefs.getString('token');
    final options = token == null
        ? null
        : Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
    return options;
  }

  //把长按菜单的英文换成中文
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

  Widget lzyfLoadingWidget(context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
          color: const Color.fromARGB(255, 197, 1, 1)),
    );
  }
}
