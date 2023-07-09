import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jverify/jverify.dart';
import 'package:lzyfs_app/network_controller.dart';
import 'sms_verification_code_login_page.dart';

class JverifyController extends GetxController {
  /// 统一 key
  final String f_result_key = "result";

  /// 错误码
  String f_code_key = "code";

  /// 回调的提示信息，统一返回 flutter 为 message
  final String f_msg_key = "message";

  /// 运营商信息
  final String f_opr_key = "operator";

  RxString _result = "token=".obs;
  final Jverify jverify = Jverify();

  RxString? _token;

  final NetworkController networkController = Get.find<NetworkController>();

  @override
  void onInit() {
    super.onInit();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // 初始化 SDK 之前添加监听
    jverify.addSDKSetupCallBackListener((JVSDKSetupEvent event) {
      print("receive sdk setup call back event :${event.toMap()}");
    });

    jverify.setDebugMode(false); // 打开调试模式
    jverify.setup(
        appKey: "cb4c10a29aef234e0c2d3b91", //"你自己应用的 AppKey",
        channel: "developer-default"); // 初始化sdk,  appKey 和 channel 只对ios设置有效

    /// 授权页面点击时间监听
    jverify.addAuthPageEventListener((JVAuthPageEvent event) {
      print("receive auth page event :${event.toMap()}");
    });
  }

  /// sdk 初始化是否完成
  void isInitSuccess() {
    jverify.isInitSuccess().then((map) {
      bool result = map[f_result_key];
      if (result) {
        _result.value = "sdk 初始换成功";
        debugPrint(_result.value);
        // Get.snackbar(_result.value, _result.value,
        //     snackPosition: SnackPosition.BOTTOM);
      } else {
        _result.value = "sdk 初始换失败";
        Get.snackbar(_result.value, _result.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  /// 判断当前网络环境是否可以发起认证
  void checkVerifyEnable() {
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        _result.value = "当前网络环境可以发起认证";
        debugPrint(_result.value);
        // Get.snackbar(_result.value, _result.value,
        //     snackPosition: SnackPosition.BOTTOM);
      } else {
        _result.value = "当前网络环境不可以发起认证";
        Get.snackbar(_result.value, _result.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  /// 获取号码认证token
  void getToken() {
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        jverify.getToken().then((map) {
          int code = map[f_code_key];
          _token?.value = map[f_msg_key];
          String operator = map[f_opr_key];
          _result.value = "[$code] message = $_token, operator = $operator";
          debugPrint(_result.value);
          // Get.snackbar(_result, _result, snackPosition: SnackPosition.BOTTOM);
        });
      } else {
        _result.value = "[2016],msg = 当前网络环境不支持认证";
        Get.snackbar(_result.value, _result.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  /// 获取短信验证码
  void getSMSCode(phoneNum) {
    if (phoneNum.isEmpty) {
      _result.value = "[3002],msg = 没有输入手机号码";
    }
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        jverify.getSMSCode(phoneNum: phoneNum).then((map) {
          print("获取短信验证码：${map.toString()}");
          int code = map[f_code_key];
          String message = map[f_msg_key];
          _result.value = "[$code] message = $message";
          debugPrint(_result.value);
        });
      } else {
        _result.value = "[3004],msg = 获取短信验证码异常";
        Get.snackbar(_result.value, _result.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  /// 登录预取号
  void preLogin() {
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        jverify.preLogin().then((map) {
          print("预取号接口回调：${map.toString()}");
          int code = map[f_code_key];
          String message = map[f_msg_key];
          _result.value = "[$code] message = $message";
        });
      } else {
        _result.value = "[2016],msg = 当前网络环境不支持认证";
        Get.snackbar(_result.value, _result.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  /// SDK 请求授权一键登录
  void loginAuth() {
    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {
        final screenSize = MediaQuery.of(Get.context!).size;
        final screenWidth = screenSize.width;
        final screenHeight = screenSize.height;
        bool isiOS = Platform.isIOS;

        /// 自定义授权的 UI 界面，以下设置的图片必须添加到资源文件里，
        /// android项目将图片存放至drawable文件夹下，可使用图片选择器的文件名,例如：btn_login.xml,入参为"btn_login"。
        /// ios项目存放在 Assets.xcassets。
        ///
        JVUIConfig uiConfig = JVUIConfig();
        // uiConfig.authBGGifPath = "main_gif";
        // uiConfig.authBGVideoPath="main_vi";
        // uiConfig.authBGVideoPath =
        //     "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        // uiConfig.authBGVideoImgPath = "main_v_bg";
        uiConfig.authBackgroundImage = "main_bg";

        uiConfig.navHidden = true;
        uiConfig.navColor = const Color.fromARGB(255, 209, 178, 142).value;
        // uiConfig.navColor = const Color.fromARGB(255, 249, 175, 135).value;
        // uiConfig.navText = "登录";
        // uiConfig.navTextColor = Colors.blue.value;
        // uiConfig.navReturnImgPath = "return_bg"; //图片必须存在

        uiConfig.logoWidth = 150;
        uiConfig.logoHeight = 150;
        //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
        uiConfig.logoOffsetY = 10;
        uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.logoHidden = false;
        uiConfig.logoImgPath = "logo";

        uiConfig.numberFieldWidth = 200;
        uiConfig.numberFieldHeight = 40;
        //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
        uiConfig.numFieldOffsetY = isiOS ? 20 : 160;
        uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
        uiConfig.numberColor = Colors.black.value;
        uiConfig.numberSize = 20;

        uiConfig.sloganOffsetY = isiOS ? 20 : 200;
        uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
        uiConfig.sloganTextColor = const Color.fromARGB(255, 84, 84, 84).value;
        uiConfig.sloganTextSize = 13;
        // uiConfig.sloganHidden = true;
        //uiConfig.sloganHidden = 0;

        uiConfig.logBtnWidth = 200;
        uiConfig.logBtnHeight = 60;
        //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
        uiConfig.logBtnOffsetY = isiOS ? 20 : 250;
        uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
        uiConfig.logBtnText = "";
        uiConfig.logBtnTextColor = Colors.white.value;
        uiConfig.logBtnTextSize = 20;
        uiConfig.logBtnTextBold = true;
        uiConfig.logBtnBackgroundPath = "login_btn_normal"; //图片必须存在
        uiConfig.loginBtnNormalImage = "login_btn_normal"; //图片必须存在
        uiConfig.loginBtnPressedImage = "login_btn_press"; //图片必须存在
        uiConfig.loginBtnUnableImage = "login_btn_unable"; //图片必须存在

        uiConfig.privacyHintToast =
            true; //only android 设置隐私条款不选中时点击登录按钮默认显示toast。

        uiConfig.privacyState = false; //设置默认勾选
        uiConfig.privacyCheckboxSize = 20;
        uiConfig.checkedImgPath = "check_image"; //图片必须存在
        uiConfig.uncheckedImgPath = "uncheck_image"; //图片必须存在
        uiConfig.privacyCheckboxInCenter = true;
        uiConfig.privacyCheckboxHidden = false;
        uiConfig.isAlertPrivacyVc = true;

        //uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
        uiConfig.privacyOffsetY = 100; // 距离底部距离
        uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.clauseName = "协议1";
        uiConfig.clauseUrl = "https://www.baidu.com";
        uiConfig.clauseBaseColor = Colors.black.value;
        uiConfig.clauseNameTwo = "协议二";
        uiConfig.clauseUrlTwo = "https://www.hao123.com";
        uiConfig.clauseColor = const Color.fromARGB(255, 183, 40, 11).value;
        uiConfig.privacyText = ["我已认真阅读并同意"];
        uiConfig.privacyTextSize = 13;
        uiConfig.privacyItem = [
          JVPrivacy("自定义协议1", "https://www.baidu.com",
              beforeName: "==", afterName: "++", separator: "*"),
        ];
        uiConfig.textVerAlignment = 1;
        uiConfig.privacyWithBookTitleMark = true;
        //uiConfig.privacyTextCenterGravity = false;
        uiConfig.authStatusBarStyle = JVIOSBarStyle.StatusBarStyleDarkContent;
        uiConfig.privacyStatusBarStyle = JVIOSBarStyle.StatusBarStyleDefault;
        uiConfig.modelTransitionStyle =
            JVIOSUIModalTransitionStyle.CrossDissolve;

        uiConfig.statusBarColorWithNav = true;
        uiConfig.virtualButtonTransparent = true;

        uiConfig.privacyStatusBarColorWithNav = true;
        uiConfig.privacyVirtualButtonTransparent = true;

        uiConfig.needStartAnim = true;
        uiConfig.needCloseAnim = true;
        uiConfig.enterAnim = "activity_slide_enter_bottom";
        uiConfig.exitAnim = "activity_slide_exit_bottom";

        uiConfig.privacyNavColor = Colors.transparent.value;
        uiConfig.privacyNavTitleTextColor = Colors.transparent.value;
        uiConfig.privacyNavTitleTextSize = 16;

        uiConfig.privacyNavTitleTitle = "ios lai le"; //only ios
        uiConfig.privacyNavReturnBtnImage = ""; //图片必须存在;

        //协议二次弹窗内容设置 -iOS
        uiConfig.agreementAlertViewTitleTexSize = 18;
        uiConfig.agreementAlertViewTitleTextColor = Colors.transparent.value;
        uiConfig.agreementAlertViewContentTextAlignment =
            JVTextAlignmentType.center;
        uiConfig.agreementAlertViewContentTextFontSize = 16;
        uiConfig.agreementAlertViewLoginBtnNormalImagePath = "";
        uiConfig.agreementAlertViewLoginBtnPressedImagePath = "";
        uiConfig.agreementAlertViewLoginBtnUnableImagePath = "";
        uiConfig.agreementAlertViewLogBtnTextColor = Colors.black.value;

        //协议二次弹窗内容设置 -Android
        JVPrivacyCheckDialogConfig privacyCheckDialogConfig =
            JVPrivacyCheckDialogConfig();
        // privacyCheckDialogConfig.width = 250;
        // privacyCheckDialogConfig.height = 100;
        privacyCheckDialogConfig.offsetX = 0;
        privacyCheckDialogConfig.offsetY = 0;
        privacyCheckDialogConfig.titleTextSize = 22;
        privacyCheckDialogConfig.gravity = "center";
        privacyCheckDialogConfig.titleTextColor = Colors.black.value;
        privacyCheckDialogConfig.contentTextGravity = "left";
        privacyCheckDialogConfig.contentTextSize = 14;
        privacyCheckDialogConfig.logBtnImgPath = "login_btn_normal";
        privacyCheckDialogConfig.logBtnTextColor = Colors.black.value;
        privacyCheckDialogConfig.enablePrivacyCheckDialog = false;
        uiConfig.privacyCheckDialogConfig = privacyCheckDialogConfig;

        //弹框模式
        // JVPopViewConfig popViewConfig = JVPopViewConfig();
        // popViewConfig.width = (screenWidth - 100.0).toInt();
        // popViewConfig.height = (screenHeight - 150.0).toInt();

        // uiConfig.popViewConfig = popViewConfig;

        /// 添加自定义的 控件 到授权界面
        List<JVCustomWidget> widgetList = [];

        // final String text_widgetId = "jv_add_custom_text"; // 标识控件 id
        // JVCustomWidget textWidget =
        //     JVCustomWidget(text_widgetId, JVCustomWidgetType.button);
        // textWidget.title = "";
        // textWidget.left = 0;
        // textWidget.top = 360;
        // textWidget.width = 750;
        // textWidget.height = 18;
        // textWidget.btnNormalImageName = "other_login_way_bg";
        // textWidget.isShowUnderline = true;
        // textWidget.textAlignment = JVTextAlignmentType.center;
        // textWidget.isClickEnable = true;

        // 添加点击事件监听
        // jverify.addClikWidgetEventListener(text_widgetId, (eventId) {
        //   print("receive listener - click widget event :$eventId");
        //   if (text_widgetId == eventId) {
        //     print("receive listener - 点击【新加 text】");
        //   }
        // });
        // widgetList.add(textWidget);

        final String message_icon = "jv_add_custom_button"; // 标识控件 id
        JVCustomWidget message_icon_button =
            JVCustomWidget(message_icon, JVCustomWidgetType.button);
        message_icon_button.title = "";
        message_icon_button.left = 0;
        message_icon_button.top = 400;
        message_icon_button.width = 750;
        message_icon_button.height = 52;
        message_icon_button.btnNormalImageName = "message_icon";
        message_icon_button.isShowUnderline = false;
        message_icon_button.backgroundColor = Colors.brown.value;
        //buttonWidget.btnNormalImageName = "";
        //buttonWidget.btnPressedImageName = "";
        //buttonWidget.textAlignment = JVTextAlignmentType.left;

        // 添加点击事件监听
        // jverify.addClikWidgetEventListener(message_icon, (eventId) {
        //   print("receive listener - click widget event :$eventId");
        //   if (message_icon == eventId) {
        //     print("receive listener - 点击【新加 button】");
        //   }
        // });
        widgetList.add(message_icon_button);
        final String btn_widgetId = "jv_add_custom_button"; // 标识控件 id
        JVCustomWidget buttonWidget =
            JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
        buttonWidget.title = "短信验证码登录";
        buttonWidget.left = 120;
        buttonWidget.top = 450;
        buttonWidget.width = 150;
        buttonWidget.height = 40;
        buttonWidget.isShowUnderline = false;
        buttonWidget.backgroundColor = Colors.brown.value;
        //buttonWidget.btnNormalImageName = "";
        //buttonWidget.btnPressedImageName = "";
        //buttonWidget.textAlignment = JVTextAlignmentType.left;

        // 添加点击事件监听
        jverify.addClikWidgetEventListener(btn_widgetId, (eventId) {
          print("receive listener - click widget event :$eventId");
          if (btn_widgetId == eventId) {
            print("receive listener - 点击【新加 button】");
            Get.to(() => SMSVerificationCodeLoginPage());
            jverify.dismissLoginAuthView();
          }
        });
        widgetList.add(buttonWidget);

        /// 步骤 1：调用接口设置 UI
        jverify.setCustomAuthorizationView(true, uiConfig,
            landscapeConfig: uiConfig, widgets: widgetList);

        /// 步骤 2：调用一键登录接口

        /// 方式一：使用同步接口 （如果想使用异步接口，则忽略此步骤，看方式二）
        /// 先，添加 loginAuthSyncApi 接口回调的监听
        jverify.addLoginAuthCallBackListener((event) {
          _result.value = "监听获取返回数据：[${event.code}] message = ${event.message}";
          print(
              "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
          // // 发起登录请求
          // String loginUrl = AppConfig.loginUrl;
          // Future<dio_.Response> res = dio.post(loginUrl, data: {
          //   "app_id": AppConfig.appId,
          //   "loginToken": event.message,
          // });
          // res.then((value) {
          //   print(value.data);
          //   Get.snackbar("获取到的结果", value.data.toString());
          //   jverify.dismissLoginAuthView();
          // });
          if (event.code == 6000) {
            networkController.loginAuthRequest(event.message);
          }
        });

        /// 再，执行同步的一键登录接口
        jverify.loginAuthSyncApi(autoDismiss: false);
      } else {
        _result.value = "[2016],msg = 当前网络环境不支持认证";
        /* 弹框模式
        JVPopViewConfig popViewConfig = JVPopViewConfig();
        popViewConfig.width = (screenWidth - 100.0).toInt();
        popViewConfig.height = (screenHeight - 150.0).toInt();

        uiConfig.popViewConfig = popViewConfig;
        */

        /*

        /// 方式二：使用异步接口 （如果想使用异步接口，则忽略此步骤，看方式二）

        /// 先，执行异步的一键登录接口
        jverify.loginAuth(true).then((map) {

          /// 再，在回调里获取 loginAuth 接口异步返回数据（如果是通过添加 JVLoginAuthCallBackListener 监听来获取返回数据，则忽略此步骤）
          int code = map[f_code_key];
          String content = map[f_msg_key];
          String operator = map[f_opr_key];
          setState(() {
           _hideLoading();
            _result = "接口异步返回数据：[$code] message = $content";
          });
          print("通过接口异步返回，获取到 loginAuth 接口返回数据，code=$code,message = $content,operator = $operator");
        });

        */
      }
    });
  }

  ///收起页面
  void dismissLoginAuthView() {
    jverify.dismissLoginAuthView();
  }

  void sendLoginToken(loginToken, method) {
    method(loginToken);
  }
}
