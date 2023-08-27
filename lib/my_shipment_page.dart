import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/app_config.dart';
import 'package:lzyfs_app/catch_error_image.dart';
import 'package:lzyfs_app/lzyf_check_box.dart';
import 'package:lzyfs_app/normal_appbar.dart';

import 'my_shipment_page_controller.dart';
import 'normal_navigate.dart';
import 'stroke_text.dart';
import 'unlogged_view.dart';

class MyShipmentPage extends StatelessWidget {
  final double cardHeight = 220;
  final double normalCardHeight = 230;
  final MyShipmentPageController controller =
      Get.put(MyShipmentPageController());
  MyShipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        body: Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.clickTab('0');
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isSelectedUndelivery.value,
                          text: '未发货',
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clickTab('2');
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isSelectedWaitToDelivery.value,
                          text: '待发货',
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clickTab('1');
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isSelectedDelivery.value,
                          text: '已发货',
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              UnloggedView(controller: controller),
              Obx(
                () => Visibility(
                  visible: controller.isLogged.value &&
                      controller.isSelectedUndelivery.value,
                  child: Expanded(
                      child: ListView.builder(
                    controller: controller.scrollController,
                    itemExtent: cardHeight,
                    itemBuilder: (BuildContext context, int index) {
                      return UndeliveryShipmentWidget(
                        controller: controller,
                        index: index,
                        onTap: () {
                          controller.selectShipmentOrder(index);
                        },
                      );
                    },
                    itemCount: controller.shipmentOrders.length,
                  )),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.isLogged.value &&
                      controller.isSelectedWaitToDelivery.value,
                  child: Expanded(
                      child: ListView.builder(
                    controller: controller.scrollController,
                    itemExtent: cardHeight,
                    itemBuilder: (BuildContext context, int index) {
                      return NormalShipmentWidget(
                        controller: controller,
                        index: index,
                        isSelectable: false,
                      );
                    },
                    itemCount: controller.shipmentOrders.length,
                  )),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.isLogged.value &&
                      controller.isSelectedDelivery.value,
                  child: Expanded(
                      child: ListView.builder(
                    controller: controller.scrollController,
                    itemExtent: cardHeight,
                    itemBuilder: (BuildContext context, int index) {
                      return NormalShipmentWidget(
                        controller: controller,
                        index: index,
                        isSelectable: false,
                        hasTrackingNumber: true,
                      );
                    },
                    itemCount: controller.shipmentOrders.length,
                  )),
                ),
              ),
            ])),
        Obx(() => Visibility(
            visible: controller.isLogged.value &&
                controller.isSelectedUndelivery.value,
            child: Positioned(
                bottom: 120,
                right: 40,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          controller.changeAddress();
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(top: 2, bottom: 5)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(7), // 设置圆角半径
                              ),
                            )),
                        child: const StrokeText(
                          text: "修改地址",
                          fontSize: 16,
                          strokeWidth: 3,
                          strokeColor: Color.fromARGB(255, 71, 71, 71),
                          color: Colors.white,
                        ))))))
      ],
    ));
  }
}

class UndeliveryShipmentWidget extends StatelessWidget {
  final controller;
  final index;
  final Function onTap;
  const UndeliveryShipmentWidget(
      {super.key,
      required this.controller,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: NormalShipmentWidget(
        controller: controller,
        index: index,
        isSelectable: true,
      ),
    );
  }
}

class NormalShipmentWidget extends StatelessWidget {
  final hasTrackingNumber;
  final isSelectable;
  final controller;
  final index;
  const NormalShipmentWidget(
      {super.key,
      required this.controller,
      required this.index,
      required this.isSelectable,
      this.hasTrackingNumber = false});

  @override
  Widget build(BuildContext context) {
    var shipmentOrder = controller.shipmentOrders[index];
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 210,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
            image: AssetImage('assets/images/cardBg.png'), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasTrackingNumber
              ? Row(
                  children: [
                    Text(
                      '运单号：${shipmentOrder['tracking_number']}',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () => controller.copyOrderNumber(
                            shipmentOrder['tracking_number'].toString()),
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
                            '复制',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          )),
                        ))
                  ],
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('运输地址：',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              isSelectable
                  ? SizedBox(
                      width: 15,
                      height: 15,
                      child: Obx(() => LzyfCheckboxWithNoOnTap(
                          value: controller.shipmentOrders[index]
                              ['isSelected'])),
                    )
                  : const SizedBox(
                      width: 30,
                      height: 30,
                    )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SelectableText(
            shipmentOrder['shipment_address'],
            style: const TextStyle(color: Colors.white, fontSize: 16),
            maxLines: 2,
            contextMenuBuilder: (context, editableTextState) =>
                AppConfig().changeMenuButtonToCN(context, editableTextState),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text('商品件数：',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              Text(
                '${shipmentOrder['user_shipment_product_items'] == null ? 0 : shipmentOrder['user_shipment_product_items'].length}件',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              var productItem =
                  shipmentOrder['user_shipment_product_items'][index];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                width: 72,
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: CatchErrorImage(
                          url: productItem['product_image'], fit: BoxFit.fill),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${productItem['product_level']}赏${productItem['product_name']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                  ],
                ),
              );
            },
            itemCount: shipmentOrder['user_shipment_product_items'] == null
                ? 0
                : shipmentOrder['user_shipment_product_items'].length,
            scrollDirection: Axis.horizontal,
          ))
        ],
      ),
    );
  }
}
