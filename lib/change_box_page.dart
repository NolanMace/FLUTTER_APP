import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/change_box_page_controller.dart';
import 'package:lzyfs_app/normal_appbar.dart';

class ChangeBoxPage extends StatelessWidget {
  final ChangeBoxPageController controller = Get.put(ChangeBoxPageController());
  ChangeBoxPage({super.key});

  final containerPadding = const EdgeInsets.only(left: 15, right: 15);

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: containerPadding,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                Segmentations(controller: controller),
                const SizedBox(height: 10),
                Obx(
                  () => Column(
                    children: List.generate(
                      controller.filteredBoxes.length,
                      (index) {
                        return GestureDetector(
                            onTap: () {
                              controller.selectBox(index);
                            },
                            child: BoxInstanceCard(
                              controller: controller,
                              index: index,
                            ));
                      },
                    ),
                  ),
                )
              ]),
            )));
  }
}

class Segmentations extends StatelessWidget {
  final ChangeBoxPageController controller;
  const Segmentations({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(103, 197, 1, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 197, 1, 1),
          width: 2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Obx(() => ListView.builder(
            controller: controller.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: controller.segmentation.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  controller.onRangeButtonClick(index);
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: controller.segmentation[index]['isSelected']
                        ? const Color.fromARGB(255, 197, 1, 1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${controller.segmentation[index]['start']} ~ ${controller.segmentation[index]['end']}箱',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}

class BoxInstanceCard extends StatelessWidget {
  final ChangeBoxPageController controller;
  final int index;
  const BoxInstanceCard(
      {super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 150,
        ),
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: controller.filteredBoxes[index]['left_num'] == 0
                  ? const Color.fromARGB(255, 85, 82, 82)
                  : const Color.fromARGB(255, 62, 12, 11),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color.fromARGB(255, 211, 168, 89),
                width: 1,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: IntrinsicWidth(
              stepHeight: 1,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: BoxNumberLabel(
                      boxNumber: controller.filteredBoxes[index]['box_number']
                          .toString(),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '剩${controller.filteredBoxes[index]['left_num']}张',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 154, 100, 100),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 120, height: 120),
                          BoxItemCounts(
                              length: controller
                                  .filteredBoxes[index]['box_item_counts']
                                  .length,
                              boxItemCounts: controller.filteredBoxes[index]
                                  ['box_item_counts'])
                        ],
                      )),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Positioned(
                      left: 0,
                      top: 20,
                      child: Image.asset(
                        'assets/images/lzyfbox.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.fill,
                      )),
                  controller.filteredBoxes[index]['left_num'] == 0
                      ? Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/sold_out.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )));
  }
}

class BoxItemCounts extends StatelessWidget {
  final int length;
  final boxItemCounts;
  const BoxItemCounts({
    super.key,
    required this.length,
    required this.boxItemCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
          runSpacing: 3,
          spacing: 30,
          children: List.generate(length, (index2) {
            return SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${boxItemCounts[index2]['product_level']}赏',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${boxItemCounts[index2]['product_left_count']}/${boxItemCounts[index2]['product_total_count']}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          })),
    );
  }
}

class BoxNumberLabel extends StatelessWidget {
  final String boxNumber;
  const BoxNumberLabel({super.key, required this.boxNumber});
  final double boxNumberLabelHeight = 16;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxNumberLabelHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            stepWidth: 20,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 211, 168, 89),
              ),
              child: Text(
                boxNumber,
                style: const TextStyle(
                  color: Color.fromARGB(255, 60, 8, 8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Triangle(
            boxNumberLabelHeight: boxNumberLabelHeight,
          ),
        ],
      ),
    );
  }
}

class Triangle extends StatelessWidget {
  final double boxNumberLabelHeight;
  const Triangle({super.key, required this.boxNumberLabelHeight});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(),
      size: Size(boxNumberLabelHeight, boxNumberLabelHeight),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 211, 168, 89) // 设置三角形的颜色，可以根据需要自定义
      ..strokeWidth = 2.0 // 设置描边宽度，这里设置为2.0
      ..style = PaintingStyle.fill; // 设置绘制样式为填充

    Path path = Path()
      ..moveTo(0, size.height) // 设置三角形的起点，这里设置在左下角
      ..lineTo(0, 0) // 画直角三角形的边，这里是左边
      ..lineTo(size.width * 0.8, 0) // 画直角三角形的底边，这里是上边
      ..close(); // 封闭路径

    canvas.drawPath(path, paint); // 绘制路径
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // 这里设置为false，表示不需要重新绘制
  }
}
