import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/stroke_text.dart';

import 'catch_error_image.dart';
import 'mine_index_page_controller.dart';

enum MineIndexMenuItemType {
  //发货管理
  shipmentManagement,
  myAddress,
  consumeRecord,
  //用户协议
  userAgreement,
  ycShipment;

  Map<String, dynamic> get iconUrl {
    switch (this) {
      case MineIndexMenuItemType.shipmentManagement:
        return {
          'url': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/shipmentIcon.png',
          'text': '发货管理'
        };
      case MineIndexMenuItemType.myAddress:
        return {
          'url': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/address.png',
          'text': '收货地址'
        };
      case MineIndexMenuItemType.consumeRecord:
        return {
          'url': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/lottery.png',
          'text': '消费记录'
        };
      case MineIndexMenuItemType.userAgreement:
        return {
          'url': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/aggreement.png',
          'text': '用户协议'
        };
      case MineIndexMenuItemType.ycShipment:
        return {
          'url': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/cloud2.png',
          'text': '云仓发货'
        };
      default:
        return {
          'url': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/lottery.png',
          'text': '消费记录'
        };
    }
  }
}

class MineIndexPage extends StatelessWidget {
  final MineIndexPageController controller = Get.put(MineIndexPageController());
  MineIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 90,
            height: 40,
            child: Column(
              children: [
                Image.network(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/mine.png',
                    width: 90,
                    height: 33,
                    fit: BoxFit.fill),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 4, 4, 6),
          toolbarHeight: 40,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MineIndexHead(controller: controller),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: MineIndexMenuItemType.values
                        .map((e) => MineIndexMenuItem(
                            title: e.iconUrl['text'],
                            iconUrl: e.iconUrl['url'],
                            onTap: () {
                              switch (e) {
                                case MineIndexMenuItemType.shipmentManagement:
                                  controller.toShipmentManagement();
                                  break;
                                case MineIndexMenuItemType.myAddress:
                                  controller.toMyAddress();
                                  break;
                                case MineIndexMenuItemType.consumeRecord:
                                  controller.toConsumeRecord();
                                  break;
                                case MineIndexMenuItemType.userAgreement:
                                  controller.toUserAgreement();
                                  break;
                                case MineIndexMenuItemType.ycShipment:
                                  controller.toYcShipment();
                                  break;
                              }
                            }))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () => controller.logout(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 192, 1, 1)),
                          //直角
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)))),
                          fixedSize:
                              MaterialStateProperty.all(const Size(150, 40))),
                      child: const StrokeText(
                          text: '退出登录',
                          fontSize: 16,
                          strokeWidth: 3,
                          color: Colors.white,
                          strokeColor: Colors.black))
                ],
              ),
            )));
  }
}

class MineIndexHead extends StatelessWidget {
  final MineIndexPageController controller;
  const MineIndexHead({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.45,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cardBg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Obx(
                  () => Visibility(
                      visible: controller.isLogged.value,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CatchErrorImage(
                            url: controller.userData['avatar_url'].toString(),
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                          ))),
                ),
                Obx(
                  () => Visibility(
                      visible: !controller.isLogged.value,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        child: Image.asset(
                          'assets/images/mrts.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(
                  () => Visibility(
                      visible: controller.isLogged.value,
                      child: Text(
                        '${controller.userData['nickname']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )),
                ),
                Obx(() => Visibility(
                    visible: !controller.isLogged.value,
                    child: GestureDetector(
                      onTap: () {
                        controller.toLogin();
                      },
                      child: const Text(
                        '请登录',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ))),
                const SizedBox(
                  width: 5,
                ),
                Obx(() => Visibility(
                    visible: controller.isLogged.value,
                    child: GestureDetector(
                        onTap: () => controller.editUserData(),
                        child: Container(
                          width: 25,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                              child: Text(
                            '编辑',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          )),
                        ))))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.toMyCoupon();
                  },
                  child: Container(
                    width: 105,
                    height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/cardBgUnselected.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/yhq.png',
                            width: 25, height: 25, fit: BoxFit.fill),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '优惠券',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 2,
                  height: 45,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/cardBgUnselected.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/xbean.png',
                            width: 30, height: 30, fit: BoxFit.fill),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '仙豆',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Obx(() => Text(
                                  '${controller.xbean}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

class MineIndexMenuItem extends StatelessWidget {
  final String title;
  final String iconUrl;
  final Function onTap;
  const MineIndexMenuItem(
      {super.key,
      required this.title,
      required this.iconUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: const BoxDecoration(
          //下边框
          border: Border(
            bottom: BorderSide(
              //设置单侧边框的样式
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CatchErrorImage(
                  url: iconUrl,
                  width: 20,
                  height: 20,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 10,
                ),
                StrokeText(
                    text: title,
                    fontSize: 12,
                    color: Colors.white,
                    strokeColor: const Color.fromARGB(255, 192, 1, 1),
                    strokeWidth: 1),
              ],
            ),
            const StrokeText(
                text: '>',
                fontSize: 12,
                color: Colors.white,
                strokeWidth: 1,
                strokeColor: Color.fromARGB(255, 192, 1, 1))
          ],
        ),
      ),
    );
  }
}
