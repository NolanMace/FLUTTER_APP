import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/stroke_text.dart';
import 'package:lzyfs_app/yfs_jjs_page_controller.dart';

class BoxPoolHead<T extends YfsJjsPageController> extends StatelessWidget {
  final String type;
  final T controller;
  final Color normalTextColor;
  const BoxPoolHead(
      {super.key,
      required this.controller,
      required this.normalTextColor,
      required this.type});

  final boxNumberStrokeColor = const Color.fromARGB(255, 197, 1, 1);

  @override
  Widget build(BuildContext context) {
    var mwidth = MediaQuery.of(context).size.width;
    return SizedBox(
        width: mwidth,
        height: mwidth * 0.4,
        child: Stack(
          children: [
            Center(
              child: Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/headBg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Obx(() {
                    return controller.dataGot.value
                        ? Row(
                            children: [
                              Image.network(controller.instance['image_url'],
                                  width:
                                      MediaQuery.of(context).size.width * 0.345,
                                  height:
                                      MediaQuery.of(context).size.width * 0.275,
                                  fit: BoxFit.fill),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.29,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Text(
                                          controller.instance['${type}_name'],
                                          style: TextStyle(
                                              color: normalTextColor,
                                              fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        child: Text(
                                          '零售价：￥${controller.instance['${type}_price'].toString()}',
                                          style: TextStyle(
                                              color: normalTextColor,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ]),
                              )
                            ],
                          )
                        : Text(
                            controller.loadingText.value,
                          );
                  })),
            ),
            Visibility(
              visible: type != 'pool',
              child: Positioned(
                  bottom: mwidth * 0.06,
                  left: mwidth * 0.1,
                  child: Image.asset(
                    'assets/images/boxNumber.png',
                    height: mwidth * 0.08,
                    width: mwidth * 0.18,
                    fit: BoxFit.fill,
                  )),
            ),
            Visibility(
                visible: type != 'pool',
                child: Positioned(
                  bottom: mwidth * 0.065,
                  left: mwidth * 0.115,
                  child: Obx(() => controller.dataGot.value
                      ? StrokeText(
                          text:
                              '第${controller.instance['box_number'].toString()}箱',
                          fontSize: 14,
                          strokeWidth: 4,
                          color: normalTextColor,
                          strokeColor: boxNumberStrokeColor,
                        )
                      : Text(
                          controller.loadingText.value,
                        )),
                ))
          ],
        ));
  }
}
