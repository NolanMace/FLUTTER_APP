import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/home_page_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / (16 / 7) * 1.55,
                    child: Image.network(
                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/CarouselSlider.png',
                      fit: BoxFit.fill,
                    ),
                  )),
                  Positioned(
                    bottom: MediaQuery.of(context).size.width / (16 / 7) * 0.20,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / (16 / 7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.87,
                                height: MediaQuery.of(context).size.width /
                                    (16 / 7) *
                                    0.87,
                                child: Obx(() => CarouselSlider(
                                      options: CarouselOptions(
                                        // aspectRatio: 16 / 7,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                (16 / 7),
                                        viewportFraction: 1.0, // 设置轮播项占据整个屏幕宽度
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                      ),
                                      items: homePageController.swiperItems
                                          .map((item) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: const BoxDecoration(
                                                color: Colors.grey,
                                              ),
                                              child: Image.network(
                                                item['image_url'],
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    )))
                          ],
                        )),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => homePageController.getBoxes("box"),
                            child: Image.network(
                              'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/yfs.png',
                              height:
                                  homePageController.navigateSelectedSizes[0] *
                                      MediaQuery.of(context).size.width,
                              width:
                                  homePageController.navigateSelectedSizes[0] *
                                      MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => homePageController.getBoxes('dq'),
                            child: Image.network(
                              'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/jjs.png',
                              height:
                                  homePageController.navigateSelectedSizes[1] *
                                      MediaQuery.of(context).size.width,
                              width:
                                  homePageController.navigateSelectedSizes[1] *
                                      MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => homePageController.getPools(),
                            child: Image.network(
                              'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/wxs.png',
                              height:
                                  homePageController.navigateSelectedSizes[2] *
                                      MediaQuery.of(context).size.width,
                              width:
                                  homePageController.navigateSelectedSizes[2] *
                                      MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 5.5,
                    mainAxisSpacing: 0.01 * MediaQuery.of(context).size.width,
                    crossAxisSpacing: 0.02 * MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.02 * MediaQuery.of(context).size.width),
                    children: List<Widget>.generate(
                        homePageController.boxesOrPools.length,
                        (index) => BoxOrPoolCard(
                              boxName:
                                  homePageController.category.value == 'pool'
                                      ? homePageController.boxesOrPools[index]
                                          ['pool_name']
                                      : homePageController.boxesOrPools[index]
                                          ['box_name'],
                              imageUrl: homePageController.boxesOrPools[index]
                                  ['image_url'],
                              boxPrice: double.tryParse(
                                  homePageController.category.value == 'pool'
                                      ? homePageController.boxesOrPools[index]
                                              ['pool_price']
                                          .toString()
                                      : homePageController.boxesOrPools[index]
                                              ['box_price']
                                          .toString())!,
                              showNewLabel: homePageController
                                  .boxesOrPools[index]['show_new_label'],
                              category: homePageController.categoryStr.value,
                            )).toList(),
                  )),
              const SizedBox(
                height: 70,
              )
            ],
          ),
        ));
  }
}

class BoxOrPoolCard extends StatelessWidget {
  final String boxName;
  final String imageUrl;
  final double boxPrice;
  final bool showNewLabel;
  final String category;
  const BoxOrPoolCard(
      {Key? key,
      required this.boxName,
      required this.imageUrl,
      required this.boxPrice,
      required this.showNewLabel,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.4 * MediaQuery.of(context).size.width,
      height: 0.6 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 0.007 * MediaQuery.of(context).size.width, // 边框宽度
          color: Colors.black, // 边框颜色
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6), // 左上角圆角
                        topRight: Radius.circular(6), // 右上角圆角
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                Positioned(
                  bottom: 0.01 * MediaQuery.of(context).size.width,
                  right: 0.2 * MediaQuery.of(context).size.width,
                  child: showNewLabel ? const NewLabel() : const SizedBox(),
                )
              ],
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                boxName,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '¥${boxPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        width: 0.1 * MediaQuery.of(context).size.width,
                        height: 0.05 * MediaQuery.of(context).size.width,
                        child: TrapezoidShape(
                          child: Center(
                            child: Text(
                              category,
                              style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ))
        ],
      ),
    );
  }
}

class NewLabel extends StatefulWidget {
  const NewLabel({super.key});

  @override
  State<NewLabel> createState() => _NewLabelState();
}

class _NewLabelState extends State<NewLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.05 * MediaQuery.of(context).size.width,
      height: 0.05 * MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _animation!.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.orange,
                blurRadius: 5.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: Image.network(
              'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/newbox.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}

class TrapezoidShape extends StatelessWidget {
  final Widget child;
  const TrapezoidShape({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrapezoidPainter(),
      child: child,
    );
  }
}

class TrapezoidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 135, 55);
    final Paint strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path path = Path()
      ..moveTo(size.width * 0.2, 0.0)
      ..lineTo(size.width * 1.0, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(TrapezoidPainter oldDelegate) => false;
}
