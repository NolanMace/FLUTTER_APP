import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/navigate_button.dart';
import 'package:lzyfs_app/stroke_text.dart';

import 'category_page_controller.dart';
import 'home_page.dart';

class CategoryPage extends StatelessWidget {
  final controller = Get.put(CategoryPageController());
  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset(
            'assets/images/back.png',
          ),
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 52,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topCenter,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
            child: Image.network(
              controller.topUrl.value,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 165),
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Image.network(
                        controller.coverUrl.value,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: StrokeText(
                          text: controller.windowName.value,
                          fontSize: 16,
                          color: Colors.white,
                          strokeColor: Colors.grey,
                          strokeWidth: 1.5),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: NavigateContainer(
                    controller: controller,
                  ),
                ),
                Obx(() => Visibility(
                    visible: controller.isShowBox.value,
                    child: Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 4.5,
                      mainAxisSpacing: 0.04 * MediaQuery.of(context).size.width,
                      crossAxisSpacing:
                          0.03 * MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      children: List<Widget>.generate(controller.boxes.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.toYfsJjsPage(controller.boxes[index]);
                          },
                          child: BoxOrPoolCard(
                            boxName: controller.boxes[index]['window_bar_name'],
                            imageUrl: controller.boxes[index]['image_url'],
                            boxPrice: double.tryParse(controller.boxes[index]
                                    ['window_bar_price']
                                .toString())!,
                            showNewLabel: controller.boxes[index]
                                ['show_new_label'],
                            category: controller.categoryStr.value,
                            labelType:
                                controller.boxes[index]['label_type'] ?? false,
                            labelUrl:
                                controller.boxes[index]['label_url'] ?? '',
                          ),
                        );
                      }).toList(),
                    )))),
                Obx(() => Visibility(
                    visible: controller.isShowDq.value,
                    child: Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 4.3,
                      mainAxisSpacing: 0.04 * MediaQuery.of(context).size.width,
                      crossAxisSpacing:
                          0.03 * MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.02 * MediaQuery.of(context).size.width),
                      children:
                          List<Widget>.generate(controller.dqs.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.toYfsJjsPage(controller.dqs[index]);
                          },
                          child: BoxOrPoolCard(
                            boxName: controller.dqs[index]['window_bar_name'],
                            imageUrl: controller.dqs[index]['image_url'],
                            boxPrice: double.tryParse(controller.dqs[index]
                                    ['window_bar_price']
                                .toString())!,
                            showNewLabel: controller.dqs[index]
                                ['show_new_label'],
                            category: controller.categoryStr.value,
                            labelType:
                                controller.dqs[index]['label_type'] ?? false,
                            labelUrl: controller.dqs[index]['label_url'] ?? '',
                          ),
                        );
                      }).toList(),
                    )))),
                Obx(() => Visibility(
                    visible: controller.isShowPool.value,
                    child: Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 4.3,
                      mainAxisSpacing: 0.04 * MediaQuery.of(context).size.width,
                      crossAxisSpacing:
                          0.03 * MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.02 * MediaQuery.of(context).size.width),
                      children: List<Widget>.generate(controller.pools.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.toWxsPage(controller.pools[index]);
                          },
                          child: BoxOrPoolCard(
                            boxName: controller.pools[index]['window_bar_name'],
                            imageUrl: controller.pools[index]['image_url'],
                            boxPrice: double.tryParse(controller.pools[index]
                                    ['window_bar_price']
                                .toString())!,
                            showNewLabel: controller.pools[index]
                                ['show_new_label'],
                            category: controller.categoryStr.value,
                            labelType:
                                controller.pools[index]['label_type'] ?? false,
                            labelUrl:
                                controller.pools[index]['label_url'] ?? '',
                          ),
                        );
                      }).toList(),
                    )))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigateContainer extends StatelessWidget {
  final CategoryPageController controller;
  const NavigateContainer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => GestureDetector(
              onTap: () => controller.switchTab(0),
              child: NavigateButton(
                text: '一番赏',
                isSelected: controller.isShowBox.value,
                fontSize: 18,
              ),
            )),
        const SizedBox(width: 40),
        Obx(() => GestureDetector(
              onTap: () => controller.switchTab(1),
              child: NavigateButton(
                text: '竞技赏',
                isSelected: controller.isShowDq.value,
                fontSize: 18,
              ),
            )),
        const SizedBox(width: 40),
        Obx(() => GestureDetector(
              onTap: () => controller.switchTab(2),
              child: NavigateButton(
                text: '无限赏',
                isSelected: controller.isShowPool.value,
                fontSize: 18,
              ),
            )),
      ],
    );
  }
}
