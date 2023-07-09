import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cabinet_page_controller.dart';
import 'stroke_text.dart';
import 'navigate_button.dart';

class GatherCard extends StatelessWidget {
  final String imageUrl;
  final int count;
  final String productName;
  const GatherCard(
      {super.key,
      required this.imageUrl,
      required this.count,
      required this.productName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.28,
        child: Container(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.width * 0.18,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                productName,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                "X$count",
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 1,
              ),
            ],
          ),
        ));
  }
}

class Cabinet extends StatelessWidget {
  Cabinet({super.key});
  final CabinetPageController controller = Get.put(CabinetPageController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 178, 142),
                  Color.fromARGB(255, 249, 175, 135)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: StrokeText(
                            text: '我的柜子',
                            fontSize: 20,
                            strokeWidth: 5,
                          ),
                        ),
                      ]),
                ),
                Obx(
                  () => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Row(children: [
                      Expanded(
                          child: Center(
                              child: GestureDetector(
                                  onTap: () =>
                                      controller.selectFirstNavigate('box'),
                                  child: NavigateButton(
                                      text: '一番赏',
                                      isSelected: controller.yfsselected.value,
                                      fontSize: 16,
                                      strokeWidth: 4)))),
                      Expanded(
                          child: Center(
                              child: GestureDetector(
                                  onTap: () =>
                                      controller.selectFirstNavigate('dq'),
                                  child: NavigateButton(
                                      text: '竞技赏',
                                      isSelected: controller.jjsselected.value,
                                      fontSize: 16,
                                      strokeWidth: 4)))),
                      Expanded(
                          child: Center(
                              child: GestureDetector(
                                  onTap: () =>
                                      controller.selectFirstNavigate('pool'),
                                  child: NavigateButton(
                                      text: '无限赏',
                                      isSelected: controller.wxsselected.value,
                                      fontSize: 16,
                                      strokeWidth: 4)))),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                DefaultTabController(
                  length: 3, // 选项卡数量
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 40,
                    child: TabBar(
                      indicatorColor: const Color.fromARGB(255, 253, 70, 34),
                      indicatorPadding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      labelColor: const Color.fromARGB(255, 253, 70, 34),
                      unselectedLabelColor:
                          const Color.fromARGB(255, 77, 77, 77),
                      labelStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontSize: 16),
                      onTap: (index) {
                        controller.selectSecondNavigate(index);
                      },
                      tabs: const [
                        Tab(text: '全部'),
                        Tab(text: '现货'),
                        Tab(text: '预售'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 20,
                    child: Center(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '共${controller.boxProducts.length + controller.dqProducts.length + controller.poolProducts.length}件商品',
                            style: const TextStyle(fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.selectAll();
                            },
                            child: SizedBox(
                              width: 40,
                              height: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: controller.selectedAll.value,
                                      child: Image.asset(
                                        'assets/images/select.png',
                                        width: 14,
                                        height: 14,
                                      )),
                                  Visibility(
                                      visible: !controller.selectedAll.value,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                      )),
                                  const Text(
                                    '全选',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )))),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Visibility(
                      visible: controller.isLogged.value,
                      child: Expanded(
                          child: GridView.count(
                              crossAxisCount: 4,
                              mainAxisSpacing:
                                  0.01 * MediaQuery.of(context).size.width,
                              crossAxisSpacing:
                                  0.02 * MediaQuery.of(context).size.width,
                              childAspectRatio: 4 / 5,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      0.03 * MediaQuery.of(context).size.width),
                              children: List.generate(
                                controller.showProducts.length,
                                (index) => GestureDetector(
                                  onTap: () => controller.onItemTapped(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: controller.showProducts[index]
                                              ['selected']
                                          ? Border.all(
                                              color: const Color.fromARGB(
                                                  255, 247, 95, 64),
                                              width: 2)
                                          : Border.all(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              width: 1),
                                      boxShadow: controller.showProducts[index]
                                              ['selected']
                                          ? const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 247, 95, 64),
                                                spreadRadius: 3,
                                                blurRadius: 3,
                                                // changes position of shadow
                                              ),
                                            ]
                                          : null,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(5), // 左上角圆角
                                              topRight:
                                                  Radius.circular(5), // 右上角圆角
                                            ),
                                            child: Image.network(
                                              controller.showProducts[index]
                                                  ['product_image_url'],
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 220, 177, 140),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              controller.showProducts[index]
                                                  ['product_name'],
                                              style:
                                                  const TextStyle(fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )))),
                ),
                Obx(
                  () => Visibility(
                    visible: !controller.isLogged.value,
                    child: Expanded(
                        child: Center(
                      child: ElevatedButton(
                          onPressed: () => controller.toLogin(),
                          child: const Text(
                            '点击登录查看更多内容',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            )),
        Positioned(
            bottom: 90,
            right: 40,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 72, 35, 3),
                    width: 3,
                  )),
              child: TextButton(
                  onPressed: () {
                    controller.countSelectedShippingProduct();
                    if (controller.selectedCabinetItemIds.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('请选择商品'),
                                titleTextStyle: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('确定'))
                                ],
                              ));
                      return;
                    } else {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent, // 背景颜色设置为透明
                        context: context,
                        isScrollControlled: true,
                        clipBehavior: Clip.antiAlias,
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.7,
                            minHeight:
                                MediaQuery.of(context).size.height * 0.4),
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 243, 212, 159),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const StrokeText(
                                          text: "打包发货",
                                          fontSize: 26,
                                          strokeWidth: 7,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                          width: double.infinity,
                                        ),
                                        Container(
                                            color: const Color.fromARGB(
                                                255, 247, 188, 80),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.6),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  controller.selectedBoxProducts
                                                          .isNotEmpty
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "一番赏商品",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                            Wrap(
                                                              spacing: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02,
                                                              runSpacing:
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                              children: List.generate(
                                                                  controller
                                                                      .selectedBoxProducts
                                                                      .length,
                                                                  (index) => GatherCard(
                                                                      imageUrl:
                                                                          controller.selectedBoxProducts[index]
                                                                              [
                                                                              "product_image_url"],
                                                                      count: controller
                                                                              .selectedBoxProducts[index]
                                                                          [
                                                                          "count"],
                                                                      productName:
                                                                          controller.selectedBoxProducts[index]
                                                                              ["product_name"])),
                                                            ),
                                                            const Divider(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      52,
                                                                      52,
                                                                      52),
                                                              height: 5,
                                                              thickness: 2,
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  controller.selectedDqProducts
                                                          .isNotEmpty
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "竞技赏商品",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                            Wrap(
                                                              spacing: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02,
                                                              runSpacing:
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                              children: List.generate(
                                                                  controller
                                                                      .selectedDqProducts
                                                                      .length,
                                                                  (index) => GatherCard(
                                                                      imageUrl:
                                                                          controller.selectedDqProducts[index]
                                                                              [
                                                                              "product_image_url"],
                                                                      count: controller
                                                                              .selectedDqProducts[index]
                                                                          [
                                                                          "count"],
                                                                      productName:
                                                                          controller.selectedDqProducts[index]
                                                                              ["product_name"])),
                                                            ),
                                                            const Divider(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      52,
                                                                      52,
                                                                      52),
                                                              height: 5,
                                                              thickness: 2,
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  controller
                                                          .selectedPoolProducts
                                                          .isNotEmpty
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "无限赏商品",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                            Wrap(
                                                              spacing: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02,
                                                              runSpacing:
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                              children: List.generate(
                                                                  controller
                                                                      .selectedPoolProducts
                                                                      .length,
                                                                  (index) => GatherCard(
                                                                      imageUrl:
                                                                          controller.selectedPoolProducts[index]
                                                                              [
                                                                              "product_image_url"],
                                                                      count: controller
                                                                              .selectedPoolProducts[index]
                                                                          [
                                                                          "count"],
                                                                      productName:
                                                                          controller.selectedPoolProducts[index]
                                                                              ["product_name"])),
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 5,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "物品总计:${controller.selectedCabinetItemIds.length}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "发货地址：",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Expanded(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Obx(
                                                        () => Visibility(
                                                            visible: controller
                                                                .selectedAddress
                                                                .value,
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6,
                                                              child: Text(
                                                                controller
                                                                    .address
                                                                    .value,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )),
                                                      ),
                                                      Obx(
                                                        () => Visibility(
                                                          visible: !controller
                                                              .selectedAddress
                                                              .value,
                                                          child: const Text(
                                                            "请选择地址",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        ">",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                "订单运费：满6件包邮，不足需支付10元运费",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  String note = "";
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            content: TextField(
                                                              maxLength: 100,
                                                              decoration: const InputDecoration(
                                                                  labelText:
                                                                      "订单留言",
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              14)),
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      .shipmentOrderNote
                                                                      .value),
                                                              onChanged:
                                                                  (value) {
                                                                note = value
                                                                    .toString();
                                                              },
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        '取消'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  controller
                                                                      .setShipmentOrderNote(
                                                                          note);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        '确定'),
                                                              ),
                                                            ],
                                                          ));
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "订单留言: ",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Obx(() => SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child: Text(
                                                          controller
                                                              .shipmentOrderNote
                                                              .value,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "需支付运费: ￥",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    controller.postage
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.red),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius.all(
                                                                        Radius.circular(
                                                                            10)),
                                                                border:
                                                                    Border.all(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      72,
                                                                      35,
                                                                      3),
                                                                  width: 3,
                                                                )),
                                                        child: TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            style: ButtonStyle(
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets.only(
                                                                        top: 2,
                                                                        bottom:
                                                                            5)),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      182,
                                                                      159,
                                                                      130),
                                                                ),
                                                                shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            7), // 设置圆角半径
                                                                  ),
                                                                )),
                                                            child: const StrokeText(
                                                              text: "确认发货",
                                                              fontSize: 16,
                                                              strokeWidth: 4,
                                                            )))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 10,
                                      child: GestureDetector(
                                        child: Image.asset(
                                          'assets/images/cancel.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(top: 2, bottom: 5)),
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 193, 2, 2),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7), // 设置圆角半径
                        ),
                      )),
                  child: const StrokeText(
                    text: "打包发货",
                    fontSize: 16,
                    strokeWidth: 4,
                  )),
            ))
      ],
    );
  }
}
