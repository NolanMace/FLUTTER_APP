import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cabinet_page_controller.dart';
import 'stroke_text.dart';

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
  final Color popupMenuTextColor = Colors.white;
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
                  'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/appbarwdsg.png',
                  width: 90,
                  height: 33,
                  fit: BoxFit.fill),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 4, 6),
        toolbarHeight: 40,
      ),
      body: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
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
                                    child: Column(
                                      children: [
                                        Visibility(
                                            visible:
                                                controller.yfsselected.value,
                                            child: Image.asset(
                                                "assets/images/yfsIconTest.png",
                                                width: 75,
                                                height: 25)),
                                        Visibility(
                                            visible:
                                                !controller.yfsselected.value,
                                            child: Image.asset(
                                                "assets/images/yfsIconUnselected.png",
                                                width: 75,
                                                height: 25)),
                                      ],
                                    )))),
                        Expanded(
                            child: Center(
                                child: GestureDetector(
                                    onTap: () =>
                                        controller.selectFirstNavigate('dq'),
                                    child: Column(
                                      children: [
                                        Visibility(
                                            visible:
                                                controller.jjsselected.value,
                                            child: Image.asset(
                                                "assets/images/jjsIcon.png",
                                                width: 75,
                                                height: 25)),
                                        Visibility(
                                            visible:
                                                !controller.jjsselected.value,
                                            child: Image.asset(
                                                "assets/images/jjsIconUnselected.png",
                                                width: 75,
                                                height: 25)),
                                      ],
                                    )))),
                        Expanded(
                            child: Center(
                                child: GestureDetector(
                                    onTap: () =>
                                        controller.selectFirstNavigate('pool'),
                                    child: Column(
                                      children: [
                                        Visibility(
                                            visible:
                                                controller.wxsselected.value,
                                            child: Image.asset(
                                                "assets/images/wxsIcon.png",
                                                width: 75,
                                                height: 25)),
                                        Visibility(
                                            visible:
                                                !controller.wxsselected.value,
                                            child: Image.asset(
                                                "assets/images/wxsIconUnselected.png",
                                                width: 75,
                                                height: 25)),
                                      ],
                                    )))),
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
                        indicatorColor: const Color(0xffc50101),
                        indicatorPadding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 5),
                        labelColor: Colors.white,
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
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
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
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
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
                                    0.03 * MediaQuery.of(context).size.width,
                                childAspectRatio: 4 / 5,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.03 *
                                        MediaQuery.of(context).size.width),
                                children: List.generate(
                                  controller.showProducts.length,
                                  (index) => GestureDetector(
                                    onTap: () => controller.onItemTapped(index),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: AspectRatio(
                                            aspectRatio: 1.0, // 设置宽高比为1:1，即正方形
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              177,
                                                              177,
                                                              177),
                                                      width: 2)),
                                              child: Stack(children: [
                                                Image.network(
                                                  controller.showProducts[index]
                                                      ['product_image_url'],
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                ),
                                                Visibility(
                                                  visible: controller
                                                          .showProducts[index]
                                                      ['selected'],
                                                  child: Image.asset(
                                                    'assets/images/selectedView.png',
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              controller.showProducts[index]
                                                  ['product_name'],
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
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
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 118, 0, 0))),
                            onPressed: () => controller.toLogin(),
                            child: const Text(
                              '点击登录查看更多内容',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              )),
          Positioned(
              bottom: 120,
              right: 40,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromARGB(255, 180, 180, 180),
                      width: 1.5,
                    ),
                    color: const Color.fromARGB(255, 53, 55, 61),
                    image: const DecorationImage(
                        image: NetworkImage(
                          "https://yfsmax.oss-cn-hangzhou.aliyuncs.com/Asset%20100.png",
                        ),
                        fit: BoxFit.fill)),
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
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.4),
                          builder: (BuildContext context) {
                            return PopUpBackground(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ShipmentStatistic(
                                    selectedBoxProducts:
                                        controller.selectedBoxProducts,
                                    selectedDqProducts:
                                        controller.selectedDqProducts,
                                    selectedPoolProducts:
                                        controller.selectedPoolProducts,
                                  ),
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
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: popupMenuTextColor,
                                            )),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "发货地址：",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: popupMenuTextColor),
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
                                                              .address.value,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  popupMenuTextColor),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: !controller
                                                        .selectedAddress.value,
                                                    child: Text(
                                                      "请选择地址",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              popupMenuTextColor),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ">",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          popupMenuTextColor),
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "订单运费：满6件包邮，不足需支付10元运费",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: popupMenuTextColor),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ShipmentNote(
                                          controller: controller,
                                          textColor: popupMenuTextColor,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "需支付运费: ￥",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: popupMenuTextColor),
                                            ),
                                            Text(
                                              controller.postage.toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                        const ConfirmShipmentButtonContainer(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(top: 2, bottom: 5)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7), // 设置圆角半径
                          ),
                        )),
                    child: const StrokeText(
                      text: "打包发货",
                      fontSize: 16,
                      strokeWidth: 3,
                      strokeColor: Color.fromARGB(255, 71, 71, 71),
                      color: Colors.white,
                    )),
              ))
        ],
      ),
    );
  }
}

class PopUpBackground extends StatelessWidget {
  final Widget child;
  const PopUpBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Stack(children: [
        Column(children: [
          const SizedBox(
            height: 25,
          ),
          Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 53, 55, 61),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border.all(
                      color: const Color.fromARGB(255, 197, 1, 1),
                      width: 4,
                      style: BorderStyle.solid)),
              child: child),
        ]),
        Positioned(
            top: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 30,
                    height: 30,
                  ),
                  Image.asset(
                    'assets/images/confirmOrder.png',
                    width: 160,
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/images/cancel.png',
                      width: 30,
                      height: 30,
                    ),
                  )
                ],
              ),
            ))
      ])
    ]);
  }
}

class ShipmentStatistic extends StatelessWidget {
  final List<dynamic> selectedBoxProducts;
  final List<dynamic> selectedDqProducts;
  final List<dynamic> selectedPoolProducts;
  const ShipmentStatistic(
      {Key? key,
      required this.selectedBoxProducts,
      required this.selectedDqProducts,
      required this.selectedPoolProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 208, 212, 221),
        width: MediaQuery.of(context).size.width * 0.9,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.width * 0.6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectedBoxProducts.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "一番赏商品",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        Wrap(
                          spacing: MediaQuery.of(context).size.width * 0.02,
                          runSpacing: MediaQuery.of(context).size.width * 0.03,
                          children: List.generate(
                              selectedBoxProducts.length,
                              (index) => GatherCard(
                                  imageUrl: selectedBoxProducts[index]
                                      ["product_image_url"],
                                  count: selectedBoxProducts[index]["count"],
                                  productName: selectedBoxProducts[index]
                                      ["product_name"])),
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 52, 52, 52),
                          height: 5,
                          thickness: 2,
                        )
                      ],
                    )
                  : const SizedBox(),
              selectedDqProducts.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "竞技赏商品",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        Wrap(
                          spacing: MediaQuery.of(context).size.width * 0.02,
                          runSpacing: MediaQuery.of(context).size.width * 0.03,
                          children: List.generate(
                              selectedDqProducts.length,
                              (index) => GatherCard(
                                  imageUrl: selectedDqProducts[index]
                                      ["product_image_url"],
                                  count: selectedDqProducts[index]["count"],
                                  productName: selectedDqProducts[index]
                                      ["product_name"])),
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 52, 52, 52),
                          height: 5,
                          thickness: 2,
                        )
                      ],
                    )
                  : const SizedBox(),
              selectedPoolProducts.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "无限赏商品",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        Wrap(
                          spacing: MediaQuery.of(context).size.width * 0.02,
                          runSpacing: MediaQuery.of(context).size.width * 0.03,
                          children: List.generate(
                              selectedPoolProducts.length,
                              (index) => GatherCard(
                                  imageUrl: selectedPoolProducts[index]
                                      ["product_image_url"],
                                  count: selectedPoolProducts[index]["count"],
                                  productName: selectedPoolProducts[index]
                                      ["product_name"])),
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }
}

class ShipmentNote extends StatelessWidget {
  final CabinetPageController controller;
  final Color textColor;
  const ShipmentNote(
      {Key? key, required this.controller, required this.textColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String note = "";
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: TextField(
                    maxLength: 100,
                    decoration: const InputDecoration(
                        labelText: "订单留言", labelStyle: TextStyle(fontSize: 14)),
                    controller: TextEditingController(
                        text: controller.shipmentOrderNote.value),
                    onChanged: (value) {
                      note = value.toString();
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.setShipmentOrderNote(note);
                        Navigator.of(context).pop();
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "订单留言: ",
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          Obx(() => SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                controller.shipmentOrderNote.value,
                style: TextStyle(fontSize: 16, color: textColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )))
        ],
      ),
    );
  }
}

class ConfirmShipmentButtonContainer extends StatelessWidget {
  const ConfirmShipmentButtonContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/confirmButtonBg.png"),
          fit: BoxFit.fill,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  )),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(top: 2, bottom: 5)),
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 197, 1, 2),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3), // 设置圆角半径
                        ),
                      )),
                  child: const StrokeText(
                    text: "确认发货",
                    fontSize: 14,
                    strokeWidth: 4,
                    color: Colors.white,
                    strokeColor: Colors.black,
                  )))
        ],
      ),
    );
  }
}
