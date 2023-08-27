import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/catch_error_image.dart';
import 'package:lzyfs_app/normal_appbar.dart';

import 'my_consum_records_page_controller.dart';
import 'normal_navigate.dart';
import 'unlogged_view.dart';

class MyConsumRecordsPage extends StatelessWidget {
  final double cardHeight = 180;
  final MyConsumRecordsPageController controller =
      Get.put(MyConsumRecordsPageController());
  MyConsumRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        body: Container(
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
                      controller.onTab(0);
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isBox.value,
                          text: '一番赏',
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.onTab(1);
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isDq.value,
                          text: '竞技赏',
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.onTab(2);
                    },
                    child: Obx(() => NavigateButton(
                          isSelected: controller.isPool.value,
                          text: '无限赏',
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
                  visible: controller.isLogged.value,
                  child: Expanded(
                      child: ListView.builder(
                    itemExtent: cardHeight,
                    itemBuilder: (BuildContext context, int index) {
                      return ConsumCardWidget(
                        consumRecord: controller.myConsumRecords[index],
                      );
                    },
                    itemCount: controller.myConsumRecords.length,
                  )),
                ),
              ),
            ])));
  }
}

class ConsumCardWidget extends StatelessWidget {
  final consumRecord;
  const ConsumCardWidget({super.key, required this.consumRecord});

  final textStyle = const TextStyle(color: Colors.white, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 150,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage('assets/images/cardBg.png'), fit: BoxFit.fill),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '消费时间：',
                style: textStyle,
              ),
              Text(
                consumRecord['date'],
                style: textStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '消费金额：',
                style: textStyle,
              ),
              Text(
                '￥${consumRecord['amountStr']}',
                style: textStyle,
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 2,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CatchErrorImage(
                      url: consumRecord['product_image_url'],
                      fit: BoxFit.cover),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${consumRecord['product_level']}赏',
                        style: textStyle,
                      ),
                      Text(
                        consumRecord['product_name'],
                        style: textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
