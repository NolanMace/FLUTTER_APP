import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/cabinet.dart';
import 'package:lzyfs_app/record.dart';
import 'package:lzyfs_app/yfs_jjs_page_controller.dart';
import 'box_pool_head.dart';
import 'popup_content.dart';
import 'preview_records_buttons_container.dart';

enum PayCount {
  one,
  three,
  five,
  all;

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
      case PayCount.all:
        return {
          'payCount': 0,
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

class YfsJjjsPage extends StatelessWidget {
  YfsJjjsPage({super.key});
  final YfsJjsPageController yfsJjsPageController =
      Get.put(YfsJjsPageController());
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
    var instance = yfsJjsPageController.instance;
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => yfsJjsPageController.back(),
            child: Image.asset(
              'assets/images/back.png',
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 4, 4, 6),
          toolbarHeight: 52,
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
            child: Stack(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      BoxPoolHead(
                        controller: yfsJjsPageController,
                        normalTextColor: normalTextColor,
                        type: 'box',
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
                                controller: yfsJjsPageController,
                              ),
                              GestureDetector(
                                onTap: () {
                                  yfsJjsPageController.toChangeBoxPage();
                                },
                                child: Image.network(
                                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/changebox_icon.png',
                                    width: 43,
                                    height: 43,
                                    fit: BoxFit.fill),
                              )
                            ]),
                      ),
                      InstanceNumberData(
                        controller: yfsJjsPageController,
                        normalTextColor: normalTextColor,
                        particularTextColor: particularTextColor,
                      ),
                      Obx(() => yfsJjsPageController.dataGot.value
                          ? Visibility(
                              visible:
                                  !yfsJjsPageController.selectedRecords.value,
                              child: BoxItemsCountGridView(
                                boxItemCounts: instance['box_item_counts'],
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: mainAxisSpacing,
                                crossAxisSpacing: crossAxisSpacing,
                                gridviewPadding: gridviewPadding,
                                normalTextColor: normalTextColor,
                              ))
                          : Text(yfsJjsPageController.loadingText.value)),
                      Obx(() => Visibility(
                          visible: yfsJjsPageController.selectedRecords.value,
                          child: ListView.builder(
                            itemCount: yfsJjsPageController.records.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemExtent: recordHeight,
                            padding: recordsListViewPadding,
                            itemBuilder: (context, length) {
                              var records = yfsJjsPageController.records;
                              return LotteryRecord(record: records[length]);
                            },
                          ))),
                      const SizedBox(
                        height: 90,
                      )
                    ])),
                Positioned(
                    right: 0,
                    bottom: 180,
                    child: GestureDetector(
                      onTap: () {
                        yfsJjsPageController.dataRefresh();
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
                                yfsJjsPageController
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
                                        controller: yfsJjsPageController,
                                        type: 'box',
                                        normalTextColor: normalTextColor,
                                        particularTextColor:
                                            particularTextColor,
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
              ],
            )));
  }
}

class InstanceNumberData extends StatelessWidget {
  final YfsJjsPageController controller;
  final Color normalTextColor;
  final Color particularTextColor;
  const InstanceNumberData(
      {super.key,
      required this.controller,
      required this.normalTextColor,
      required this.particularTextColor});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '本箱还剩',
            style: TextStyle(
                color: normalTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            controller.dataGot.value
                ? controller.instance['left_num'].toString()
                : '0',
            style: TextStyle(
                color: particularTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            '/',
            style: TextStyle(color: normalTextColor, fontSize: 14),
          ),
          Text(
            controller.dataGot.value
                ? controller.instance['total_num'].toString()
                : '0',
            style: TextStyle(
                color: normalTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class BoxItemsCountGridView extends StatelessWidget {
  final controller = Get.find<YfsJjsPageController>();
  final List boxItemCounts;
  final int crossAxisCount;
  final EdgeInsetsGeometry gridviewPadding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio = 2 / 3;
  final Color normalTextColor;
  BoxItemsCountGridView(
      {super.key,
      required this.boxItemCounts,
      required this.crossAxisCount,
      required this.gridviewPadding,
      required this.mainAxisSpacing,
      required this.crossAxisSpacing,
      required this.normalTextColor});

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
          boxItemCounts.length,
          (index) => Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 197, 1, 1),
                              width: 2)),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.toProductDetail(boxItemCounts[index]);
                            },
                            child: Image.network(
                                boxItemCounts[index]['product_image_url'],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    AppConfig().lzyfLoadingWidget(
                                        context, child, loadingProgress)),
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
                                      '${boxItemCounts[index]['product_level']}赏',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        boxItemCounts[index]['product_name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: normalTextColor),
                      ),
                      Row(
                        children: [
                          Text(
                            boxItemCounts[index]['product_left_count']
                                .toString(),
                            style:
                                TextStyle(fontSize: 12, color: normalTextColor),
                          ),
                          Text(
                            '/',
                            style:
                                TextStyle(fontSize: 12, color: normalTextColor),
                          ),
                          Text(
                            boxItemCounts[index]['product_total_count']
                                .toString(),
                            style:
                                TextStyle(fontSize: 12, color: normalTextColor),
                          ),
                        ],
                      ),
                      Text(
                        boxItemCounts[index]['oddStr'],
                        style: TextStyle(fontSize: 12, color: normalTextColor),
                      )
                    ],
                  ))
                ],
              )),
    );
  }
}
