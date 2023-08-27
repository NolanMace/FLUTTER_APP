import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lzyf_check_box.dart';
import 'stroke_text.dart';

class PopupContent extends StatelessWidget {
  final controller;
  final String type;
  final Color normalTextColor;
  final Color particularTextColor;
  const PopupContent({
    super.key,
    required this.controller,
    required this.type,
    required this.normalTextColor,
    required this.particularTextColor,
  });

  @override
  Widget build(BuildContext context) {
    var mwidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: mwidth,
      height: 470,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(
                left: mwidth * 0.05,
                right: mwidth * 0.05,
                top: mwidth * 0.08,
              ),
              child: Column(
                children: [
                  PopupContentHead(
                    coverUrl: controller.instance['image_url'],
                    boxOrPoolName: controller.instance['${type}_name'],
                    unitPriceStr: (controller.instance['${type}_price'])
                        .toStringAsFixed(2),
                    particularTextColor: particularTextColor,
                    normalTextColor: normalTextColor,
                    lotteryCount: controller.lotteryCount,
                    paymentAmountStr: controller.paymentAmountStr,
                  ),
                  SizedBox(
                    height: mwidth * 0.04,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: Obx(
                        () => Row(
                          children: [
                            LzyfCheckBox(
                              value: controller.isXbeanUsed.value,
                              onChanged: () {
                                controller.useXbean();
                              },
                            ),
                            SizedBox(
                              width: mwidth * 0.02,
                            ),
                            Expanded(
                                child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: -1,
                                  child: Text(
                                    '使用仙豆(剩余${controller.xbean.value})',
                                    style: TextStyle(
                                      color: normalTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      )),
                  SizedBox(
                    height: mwidth * 0.04,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 20,
                            child: LzyfCheckBox(
                              value: controller.agree.value,
                              onChanged: () {
                                controller.agreeProtocol();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mwidth * 0.02,
                        ),
                        Expanded(
                            child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: -1,
                              right: 0,
                              child: Text(
                                '本人已满18周岁且具备完全行为能力,支付即视为同意《用户协议》',
                                maxLines: 2,
                                style: TextStyle(
                                  color: normalTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mwidth * 0.02,
                  ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() => GestureDetector(
                            onTap: () {
                              controller.navigateToCouponPage();
                            },
                            child: Text(
                              '${controller.couponDescription.value} >',
                              style: TextStyle(
                                color: normalTextColor,
                                fontSize: 14,
                              ),
                            )))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mwidth * 0.04,
                  ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          '《发货须知》',
                          style: TextStyle(
                            color: normalTextColor,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: normalTextColor,
                  ),
                ],
              )),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: mwidth * 0.05,
              right: mwidth * 0.05,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/confirmButtonBg.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: mwidth * 0.3,
                  child: Row(
                    children: [
                      Text(
                        '总计:￥',
                        style: TextStyle(
                          color: normalTextColor,
                          fontSize: 14,
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.paymentAmountAfterDiscountStr.value,
                          style: TextStyle(
                            color: particularTextColor,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: mwidth * 0.3,
                  height: mwidth * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      )),
                  child: TextButton(
                      onPressed: () {
                        controller.pay();
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 4, bottom: 5)),
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 197, 1, 2),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3), // 设置圆角半径
                            ),
                          )),
                      child: const StrokeText(
                        text: "确认支付",
                        fontSize: 16,
                        strokeWidth: 4,
                        color: Colors.white,
                        strokeColor: Colors.black,
                      )),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class PopupContentHead extends StatelessWidget {
  final String coverUrl;
  final String boxOrPoolName;
  final String unitPriceStr;
  final Color particularTextColor;
  final Color normalTextColor;
  final int lotteryCount;
  final String paymentAmountStr;
  const PopupContentHead(
      {super.key,
      required this.coverUrl,
      required this.boxOrPoolName,
      required this.unitPriceStr,
      required this.particularTextColor,
      required this.normalTextColor,
      required this.lotteryCount,
      required this.paymentAmountStr});

  @override
  Widget build(BuildContext context) {
    var mwidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            padding: EdgeInsets.only(
              left: mwidth * 0.85 * 0.05,
              right: mwidth * 0.85 * 0.05,
              top: mwidth * 0.85 * 0.05,
              bottom: mwidth * 0.85 * 0.05,
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 208, 212, 221),
            ),
            child: Row(
              children: [
                AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Image.network(
                        coverUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    )),
                SizedBox(
                  width: mwidth * 0.85 * 0.05,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boxOrPoolName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: mwidth * 0.85 * 0.01,
                    ),
                    const Text(
                      '名称：明信片',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: mwidth * 0.85 * 0.01,
                    ),
                    Row(
                      children: [
                        const Text('单价：'),
                        Text(
                          '￥$unitPriceStr',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: particularTextColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mwidth * 0.85 * 0.01,
                    ),
                    Text(
                      '数量：$lotteryCount',
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ))
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 197, 1, 2)),
            padding: EdgeInsets.only(
              left: mwidth * 0.85 * 0.05,
              right: mwidth * 0.85 * 0.05,
              top: mwidth * 0.85 * 0.01,
              bottom: mwidth * 0.85 * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '明信片x$lotteryCount',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: normalTextColor),
                ),
                SizedBox(
                  width: mwidth * 0.85 * 0.05,
                ),
                Text(
                  '总计：￥$paymentAmountStr',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: normalTextColor),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
