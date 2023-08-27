import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/normal_appbar.dart';

import 'coupon_widget.dart';
import 'use_coupon_page_controller.dart';

class UseCouponPage extends StatelessWidget {
  UseCouponPage({super.key});
  final UseCouponPageController controller = Get.put(UseCouponPageController());

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Obx(() => ListView.builder(
                  itemExtent: 120,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectCoupon(index);
                      },
                      child: CouponWidget(
                        controller: controller,
                        index: index,
                      ),
                    );
                  },
                  itemCount: controller.coupons.length,
                ))));
  }
}
