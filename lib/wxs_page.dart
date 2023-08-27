import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/normal_appbar.dart';
import 'package:lzyfs_app/record.dart';

import 'app_config.dart';
import 'box_pool_head.dart';
import 'popup_background.dart';
import 'popup_content.dart';
import 'preview_records_buttons_container.dart';
import 'wxs_page_controller.dart';

enum PayCount {
  one,
  three,
  five,
  ten;

  Map<String, dynamic> get payCountMap {
    switch (this) {
      case PayCount.one:
        return {
          'payCount': 1,
          'iconUrl': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/payOne.png'
        };
      case PayCount.three:
        return {
          'payCount': 3,
          'iconUrl': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/payThree.png'
        };
      case PayCount.five:
        return {
          'payCount': 5,
          'iconUrl': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/payFive.png'
        };
      case PayCount.ten:
        return {
          'payCount': 10,
          'iconUrl': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/payAll.png'
        };
      default:
        return {
          'payCount': 1,
          'iconUrl': 'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/payOne.png'
        };
    }
  }
}

class WxsPage extends StatelessWidget {
  final controller = Get.put(WxsPageController());
  WxsPage({super.key});

  //字体颜色，普通字体和特殊字体
  final Color normalTextColor = Colors.white;
  final Color particularTextColor = const Color.fromARGB(255, 197, 1, 1);
  //商品网格参数
  final int crossAxisCount = 3;
  final EdgeInsets gridviewPadding =
      const EdgeInsets.only(left: 10, right: 10, top: 10);
  final double mainAxisSpacing = 5;
  final double crossAxisSpacing = 10;

//记录列表参数
  final double recordHeight = 75; //每个记录的高度
  final EdgeInsets recordsListViewPadding =
      const EdgeInsets.only(left: 15, right: 15, top: 10);

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        isBackToHome: true,
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
            child: Stack(children: [
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BoxPoolHead(
                      controller: controller,
                      normalTextColor: normalTextColor,
                      type: 'pool',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 43,
                              height: 43,
                            ),
                            PreviewRecordsButtonsContainer(
                              controller: controller,
                            ),
                            const SizedBox(
                              width: 43,
                              height: 43,
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => controller.dataGot.value
                          ? Visibility(
                              visible: !controller.selectedRecords.value,
                              child: PoolInstanceListView(
                                controller: controller,
                                normalTextColor: normalTextColor,
                                particularTextColor: particularTextColor,
                              ))
                          : Text(controller.loadingText.value),
                    ),
                    Obx(() => Visibility(
                          visible: controller.selectedRecords.value,
                          child: PoolRecordListView(
                            controller: controller,
                            poolRecords: controller.poolRecords.value,
                          ),
                        )),
                    const SizedBox(
                      height: 90,
                    ),
                  ])),
              Positioned(
                  right: 0,
                  bottom: 180,
                  child: GestureDetector(
                    onTap: () {
                      controller.dataRefresh();
                    },
                    child: SizedBox(
                      width: 43,
                      height: 43,
                      child: Image.network(
                        'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/refresh.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
              Positioned(
                bottom: 50,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: PayCount.values
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              controller
                                  .setLotteryCount(e.payCountMap['payCount']);
                              showModalBottomSheet(
                                  backgroundColor:
                                      Colors.transparent, // 背景颜色设置为透明
                                  context: context,
                                  isScrollControlled: true,
                                  clipBehavior: Clip.antiAlias,
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      minHeight:
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                  builder: (BuildContext context) {
                                    return PopUpBackground(
                                        child: PopupContent(
                                      controller: controller,
                                      type: 'pool',
                                      normalTextColor: normalTextColor,
                                      particularTextColor: particularTextColor,
                                    ));
                                  });
                            },
                            child: Image.network(
                              e.payCountMap['iconUrl'],
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.2,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            ])));
  }
}

class PoolInstanceListView extends StatelessWidget {
  final Color normalTextColor;
  final Color particularTextColor;
  final WxsPageController controller;
  const PoolInstanceListView(
      {super.key,
      required this.controller,
      required this.normalTextColor,
      required this.particularTextColor});
  final padding = const EdgeInsets.only(left: 15, right: 15);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: padding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.result.length,
        itemBuilder: (context, index) {
          var item = controller.result[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.network(
                        'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/letter/${item['product_level']}.png',
                        height: 22,
                        fit: BoxFit.fitHeight,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '获得概率：${item['probability_str']}%',
                        style: TextStyle(
                          color: normalTextColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 300,
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(255, 255, 195, 33),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              PoolProductGridView(
                  productList: controller.result[index]['products'],
                  normalTextColor: normalTextColor,
                  onTap: controller.toProductDetail),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }
}

class PoolProductGridView extends StatelessWidget {
  final Function(dynamic) onTap;
  final List productList;
  final int crossAxisCount = 4;
  final EdgeInsets gridviewPadding = const EdgeInsets.only(top: 5);
  final double mainAxisSpacing = 10;
  final double crossAxisSpacing = 10;
  final double childAspectRatio = 5 / 6;
  final Color normalTextColor;
  const PoolProductGridView(
      {super.key,
      required this.productList,
      required this.normalTextColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        padding: gridviewPadding,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        children: List.generate(
            productList.length,
            (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 177, 177, 177),
                                    width: 2)),
                            child: GestureDetector(
                              onTap: () {
                                onTap(productList[index]);
                              },
                              child: Image.network(
                                  productList[index]['product_image_url'],
                                  fit: BoxFit.fill,
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          AppConfig().lzyfLoadingWidget(
                                              context, child, loadingProgress)),
                            ))),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        productList[index]['product_name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: normalTextColor),
                      ),
                    ))
                  ],
                )));
  }
}

class PoolRecordListView extends StatelessWidget {
  final WxsPageController controller;
  final List poolRecords;
  const PoolRecordListView(
      {super.key, required this.controller, required this.poolRecords});
  final padding = const EdgeInsets.only(left: 17, right: 17);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: padding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.poolRecords.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Obx(
                () => PoolRecordsFromLevel(
                  records: controller.poolRecords.value[index],
                  toUnfold: () {
                    controller.toUnfold(index);
                  },
                  index: index,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}

class PoolRecordsFromLevel extends StatelessWidget {
  final Function toUnfold;
  final int index;
  final Map records;
  final double recordHeight = 75;
  const PoolRecordsFromLevel(
      {super.key,
      required this.records,
      required this.toUnfold,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: records['isUnfold']
          ? records['records'].length * recordHeight + 40
          : recordHeight + 40,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            records['isUnfold']
                ? Column(
                    children: List.generate(
                        records['records'].length,
                        (index) =>
                            LotteryRecord(record: records['records'][index])),
                  )
                : LotteryRecord(record: records['records'][0]),
            const Divider(
              height: 4,
              thickness: 2,
              color: Color.fromARGB(255, 197, 1, 1),
            ),
            GestureDetector(
              onTap: () {
                toUnfold();
              },
              child: Image.asset(
                records['isUnfold']
                    ? 'assets/images/arrow_up.png'
                    : 'assets/images/arrow_down.png',
                width: 50,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
