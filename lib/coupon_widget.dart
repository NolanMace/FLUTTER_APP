import 'package:flutter/material.dart';

class CouponWidget extends StatelessWidget {
  final controller;
  final int index;
  const CouponWidget({super.key, this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: controller.coupons[index]['isAvailable'] ? 1.0 : 0.5,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/couponBG1.png'),
              fit: BoxFit.fill),
        ),
        child: Row(
          children: [
            Container(
              width: 95,
              height: 110,
              margin: const EdgeInsets.only(left: 5),
              color: const Color.fromARGB(255, 183, 23, 11),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                          visible: !controller.coupons[index]['discount_type'],
                          child: const Text(
                            '￥',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      Text(
                        controller.coupons[index]['discount_value'],
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Visibility(
                          visible: controller.coupons[index]['discount_type'],
                          child: const Text(
                            '折',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '满${controller.coupons[index]['minimum_order_amount']}减',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.coupons[index]['coupon_name'],
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  controller.coupons[index]['description'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      controller.coupons[index]['start_date'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      '~',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      controller.coupons[index]['end_date'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
