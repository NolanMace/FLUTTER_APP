import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_coupon_page_controller.dart';
import 'normal_appbar.dart';
import 'normal_navigate.dart';
import 'unlogged_view.dart';

class MyCouponPage extends StatelessWidget {
  final MyCouponPageController controller = Get.put(MyCouponPageController());
  MyCouponPage({super.key});

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
            child: Column(
              children: [
                NavigateContainer(
                  controller: controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                UnloggedView(controller: controller),
                Obx(
                  () => Visibility(
                    visible:
                        controller.isLogged.value && controller.unUse.value,
                    child: Expanded(
                        child: ListView.builder(
                      itemExtent: 120,
                      itemBuilder: (BuildContext context, int index) {
                        return NormalCouponWidget(
                          coupon: controller.unUsecoupons[index],
                        );
                      },
                      itemCount: controller.unUsecoupons.length,
                    )),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isLogged.value && controller.used.value,
                    child: Expanded(
                        child: ListView.builder(
                      itemExtent: 130,
                      itemBuilder: (BuildContext context, int index) {
                        return NormalCouponWidget(
                          coupon: controller.usedCoupons[index],
                        );
                      },
                      itemCount: controller.usedCoupons.length,
                    )),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible:
                        controller.isLogged.value && controller.expired.value,
                    child: Expanded(
                        child: ListView.builder(
                      itemExtent: 130,
                      itemBuilder: (BuildContext context, int index) {
                        return NormalCouponWidget(
                          coupon: controller.expeiredCoupon[index],
                        );
                      },
                      itemCount: controller.expeiredCoupon.length,
                    )),
                  ),
                ),
              ],
            )));
  }
}

class NormalCouponWidget extends StatelessWidget {
  final coupon;
  const NormalCouponWidget({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/couponBG1.png'), fit: BoxFit.fill),
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
                        visible: !coupon['discount_type'],
                        child: const Text(
                          '￥',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                    Text(
                      coupon['discount_value'],
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                        visible: coupon['discount_type'],
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
                  '满${coupon['minimum_order_amount']}减',
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
                coupon['coupon_name'],
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                coupon['description'],
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
                    coupon['start_date'],
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
                    coupon['end_date'],
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
    );
  }
}
