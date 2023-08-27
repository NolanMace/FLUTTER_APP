import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';

class ResultPageController extends GetxController {
  final Dio dio = Dio();
  var products = [].obs;
  int retryCount = 0;
  int maxRetryCount = 4;
  String payType = '';
  final String boxResultUrl = AppConfig.getUserBoxLotteryRecordsByOutTradeNo;
  final String dqResultUrl = AppConfig.getUserDqLotteryRecordsByOutTradeNo;
  final String poolResultUrl = AppConfig.getUserPoolLotteryRecordsByOutTradeNo;

  void requestData(String url) async {
    try {
      var options = await AppConfig.getOptions();
      if (options == null) {
        return;
      }
      var response = await dio.get(url, options: options);
      if (response.statusCode == 200) {
        print(response.data);
        products.value = response.data ?? [];
        products.refresh();
      } else {
        if (retryCount < maxRetryCount) {
          retryCount++;
          Future.delayed(const Duration(milliseconds: 500), () {
            requestData(url);
          });
        }
      }
    } catch (e) {
      print(e);
      if (retryCount < maxRetryCount) {
        retryCount++;
        Future.delayed(const Duration(milliseconds: 500), () {
          requestData(url);
        });
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    payType = data['pay_type'].toString();
    if (data['pay_type'] == 'box') {
      requestData('$boxResultUrl?out_trade_no=${data['out_trade_no']}');
    } else if (data['pay_type'] == 'dq') {
      requestData('$dqResultUrl?out_trade_no=${data['out_trade_no']}');
    } else if (data['pay_type'] == 'pool') {
      requestData('$poolResultUrl?out_trade_no=${data['out_trade_no']}');
    }
  }
}
