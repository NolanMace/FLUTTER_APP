import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/normal_appbar.dart';

import 'my_shipment_page.dart';
import 'my_shipment_page_controller.dart';
import 'normal_navigate.dart';
import 'stroke_text.dart';
import 'unlogged_view.dart';

class YcShipmentPage extends StatelessWidget {
  final double cardHeight = 220;
  final double normalCardHeight = 230;
  final MyShipmentPageController controller =
      Get.put(MyShipmentPageController());
  YcShipmentPage({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      controller.clickTab('3');
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isSelectedUncomposed.value,
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
                      controller.isSelectedUncomposed.value,
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
                          controller.toExchangeYcShipment();
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
                          text: "点击兑换",
                          fontSize: 16,
                          strokeWidth: 3,
                          strokeColor: Color.fromARGB(255, 71, 71, 71),
                          color: Colors.white,
                        ))))))
      ],
    ));
  }
}
