import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/wxs_page_controller.dart';
import 'package:lzyfs_app/yfs_jjs_page_controller.dart';
import 'normal_appbar.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var fromWhere = Get.parameters['fromWhere'];
    var controller = fromWhere == 'box'
        ? Get.find<YfsJjsPageController>()
        : Get.find<WxsPageController>();
    return NormalAppBar(
      isBackToHome: false,
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 4 / 5,
              height: 450,
              viewportFraction: 1,
              initialPage: controller.selectedProductIndex,
            ),
            items: controller.productData
                .map<Widget>(
                  (item) => Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          item['product_image_url'],
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            item['product_name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item['detailStr'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
