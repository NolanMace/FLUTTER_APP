import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/back_home.dart';
import 'package:lzyfs_app/normal_appbar.dart';
import 'package:lzyfs_app/result_page_controller.dart';
import 'package:lzyfs_app/wxs_page_controller.dart';

import 'stroke_text.dart';
import 'yfs_jjs_page_controller.dart';

class ResultPage extends StatelessWidget {
  final String buttonImage =
      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/cardBg.png'; //按钮背景图
  final ResultPageController controller = Get.put(ResultPageController());
  ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/congratulation.png',
                  width: 160,
                  height: 37,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Obx(
                      () => GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        childAspectRatio: 4 / 5,
                        children: List.generate(
                          controller.products.length,
                          (index) {
                            var item = controller.products[index];
                            return ResultCard(
                              product: item,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 50,
                        left: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    BackHome.backHome(index: 1);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(buttonImage),
                                            fit: BoxFit.fill)),
                                    child: const Center(
                                        child: StrokeText(
                                      text: '我的赏柜',
                                      fontSize: 16,
                                      color: Colors.white,
                                      strokeColor: Colors.black,
                                      strokeWidth: 5,
                                    )),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    if (controller.payType != 'pool') {
                                      var yfsJjsPageController =
                                          Get.find<YfsJjsPageController>();
                                      yfsJjsPageController.dataRefresh();
                                      Get.back();
                                    } else {
                                      var wxsController =
                                          Get.find<WxsPageController>();
                                      wxsController.dataRefresh();
                                      Get.back();
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(buttonImage),
                                            fit: BoxFit.fill)),
                                    child: const Center(
                                        child: StrokeText(
                                      text: '继续抽赏',
                                      fontSize: 16,
                                      color: Colors.white,
                                      strokeColor: Colors.black,
                                      strokeWidth: 2,
                                    )),
                                  ))
                            ],
                          ),
                        ))
                  ],
                ))
              ],
            )));
  }
}

class ResultCard extends StatelessWidget {
  final dynamic product;

  const ResultCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  Image.network(
                    product['product_image_url'],
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 60,
                        height: 20,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Color.fromARGB(255, 197, 1, 1),
                        ])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${product['product_level']}赏',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ))
                ],
              )),
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.only(top: 1),
          child: Text(
            product['product_name'],
            style: const TextStyle(fontSize: 14, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ))
      ],
    );
  }
}
