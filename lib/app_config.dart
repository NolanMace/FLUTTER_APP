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
  static const String getUserCouponByPhoneAndAppId =
      '${apiBaseUrl}GetUserCouponByPhoneAndAppId';
  static const String updateAvatarUrlByPhoneAndAppId =
      '${apiBaseUrl}UpdateAvatarUrlByPhoneAndAppId';
  static const String updateNicknameByPhoneAndAppId =
      '${apiBaseUrl}UpdateNicknameByPhoneAndAppId';
  static const String getUserAvatarAndNicknameByPhoneAndAppId =
      '${apiBaseUrl}GetUserAvatarAndNicknameByPhoneAndAppId';
  static const String getAppSwiperItemsByAppId =
      '${apiBaseUrl}GetAppSwiperItemsByAppId';
}
