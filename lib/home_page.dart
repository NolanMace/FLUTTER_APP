import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/home_page_controller.dart';
import 'package:lzyfs_app/stroke_text.dart';

import 'catch_error_image.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 90,
            height: 52,
            child: Column(
              children: [
                Image.network(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/logo.png',
                    width: 90,
                    height: 40,
                    fit: BoxFit.fill),
                const SizedBox(height: 12),
              ],
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
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.87,
                    height: MediaQuery.of(context).size.width / (16 / 7) * 0.87,
                    child: Obx(
                      () => ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              // aspectRatio: 16 / 7,
                              height:
                                  MediaQuery.of(context).size.width / (16 / 7),
                              viewportFraction: 1.0, // 设置轮播项占据整个屏幕宽度
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              onPageChanged: (index, reason) =>
                                  {homePageController.onSwiperChange(index)},
                            ),
                            items: homePageController.swiperItems.map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      child: CatchErrorImage(
                                        url: item['image_url'],
                                        fit: BoxFit.cover,
                                      ));
                                },
                              );
                            }).toList(),
                          )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Obx(() => LzyfCarouselSliderIndicator(
                        index: homePageController.swiperCurrentIndex.value,
                        itemCount: homePageController.swiperItems.length,
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 80,
                      child: Obx(() => WinbarContainer(
                            items: homePageController.winbars.value,
                          ))),
                  const SizedBox(height: 5),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: GestureDetector(
                                onTap: () => homePageController.getBoxes("box"),
                                child: HomePageFirstNavigateButton(
                                  selctedUrl:
                                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/selectedyfs.png',
                                  unselectedUrl:
                                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/yfs.png',
                                  selectedType:
                                      homePageController.category.value,
                                  type: 'box',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: GestureDetector(
                                onTap: () => homePageController.getBoxes('dq'),
                                child: HomePageFirstNavigateButton(
                                  selctedUrl:
                                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/selectedjjs.png',
                                  unselectedUrl:
                                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/jjs.png',
                                  selectedType:
                                      homePageController.category.value,
                                  type: 'dq',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: GestureDetector(
                                  onTap: () => homePageController.getPools(),
                                  child: HomePageFirstNavigateButton(
                                    selctedUrl:
                                        'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/selectedwxs.png',
                                    unselectedUrl:
                                        'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/wxs.png',
                                    selectedType:
                                        homePageController.category.value,
                                    type: 'pool',
                                  )),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  Obx(() => GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 4.5,
                        mainAxisSpacing:
                            0.03 * MediaQuery.of(context).size.width,
                        crossAxisSpacing:
                            0.02 * MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                0.02 * MediaQuery.of(context).size.width),
                        children: List<Widget>.generate(
                            homePageController.boxesOrPools.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              if (homePageController.category.value == 'pool') {
                                homePageController.toWxsPage(
                                    homePageController.boxesOrPools[index]);
                              } else {
                                homePageController.toYfsJjsPage(
                                    homePageController.boxesOrPools[index]);
                              }
                            },
                            child: BoxOrPoolCard(
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
                              labelType: homePageController.boxesOrPools[index]
                                      ['label_type'] ??
                                  false,
                              labelUrl: homePageController.boxesOrPools[index]
                                      ['label_url'] ??
                                  '',
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            )));
  }
}

class LzyfCarouselSliderIndicator extends StatelessWidget {
  final int index;
  final int itemCount;
  const LzyfCarouselSliderIndicator(
      {Key? key, required this.index, required this.itemCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (idx) {
        bool isActive = idx == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 20.0 : 8.0,
          height: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isActive
                ? const Color.fromARGB(255, 197, 1, 2)
                : const Color.fromARGB(255, 143, 143, 142),
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }).toList(),
    );
  }
}

class WinbarContainer extends StatelessWidget {
  final List<dynamic> items;
  const WinbarContainer({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.generate(
            items.length,
            (index) => GestureDetector(
                  onTap: () {
                    Get.toNamed('/categoryPage', arguments: items[index]);
                  },
                  child: SizedBox(
                    width: 120,
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                            child: Stack(
                          children: [
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                      items[index]['window_page_url'],
                                      width: 110,
                                      height: 35,
                                      fit: BoxFit.cover),
                                )),
                            Positioned(
                                bottom: 0,
                                right: 2,
                                child: Image.network(items[index]['people_url'],
                                    width: 35,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high)),
                            Positioned(
                                top: 30,
                                left: 5,
                                child: StrokeText(
                                    text: items[index]['window_name'],
                                    fontSize: 14,
                                    color: Colors.white,
                                    strokeColor: Colors.black,
                                    strokeWidth: 3)),
                          ],
                        )),
                        const SizedBox(width: 10)
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}

class HomePageFirstNavigateButton extends StatelessWidget {
  final String selectedType;
  final String type;
  final String unselectedUrl;
  final String selctedUrl;
  const HomePageFirstNavigateButton(
      {Key? key,
      required this.selectedType,
      required this.type,
      required this.unselectedUrl,
      required this.selctedUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      selectedType == type ? selctedUrl : unselectedUrl,
      height: 0.15 * MediaQuery.of(context).size.width,
      width: 0.25 * MediaQuery.of(context).size.width,
    );
  }
}

class BoxOrPoolCard extends StatelessWidget {
  final String boxName;
  final String imageUrl;
  final double boxPrice;
  final bool showNewLabel;
  final String category;
  final bool labelType;
  final String labelUrl;
  const BoxOrPoolCard(
      {Key? key,
      required this.boxName,
      required this.imageUrl,
      required this.boxPrice,
      required this.showNewLabel,
      required this.category,
      this.labelType = false,
      this.labelUrl = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.4 * MediaQuery.of(context).size.width,
      height: 0.5 * MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: AspectRatio(
                    aspectRatio: 5 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 218, 1, 1),
                              width: 2)),
                      child: CatchErrorImage(url: imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.03 * MediaQuery.of(context).size.width,
                  left: 0.03 * MediaQuery.of(context).size.width,
                  child: showNewLabel ? const NewLabel() : const SizedBox(),
                ),
                Positioned(
                  top: 0.01 * MediaQuery.of(context).size.width,
                  right: 0.01 * MediaQuery.of(context).size.width,
                  child: Container(
                    width: 0.15 * MediaQuery.of(context).size.width,
                    height: 0.05 * MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.01 * MediaQuery.of(context).size.width),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/label.png'),
                            fit: BoxFit.fill)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        category,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/huidi.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  boxName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                          width: 0.12 * MediaQuery.of(context).size.width,
                          height: 0.06 * MediaQuery.of(context).size.width,
                          child: labelType
                              ? CatchErrorImage(url: labelUrl, fit: BoxFit.fill)
                              : const SizedBox(),
                        )
                      ],
                    ))
              ],
            ),
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
                spreadRadius: 1.0,
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
