import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/normal_appbar.dart';
import 'package:lzyfs_app/stroke_text.dart';

import 'exchange_ycshipment_page_controller.dart';

class ExchangeYcshipmentPage extends StatelessWidget {
  final controller = Get.put(ExchangeYcshipmentPageController());
  ExchangeYcshipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NormalAppBar(
        body: Stack(children: [
      Container(
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
          child: Column(children: [
            Obx(() => AddressCardWidget(address: controller.address.value)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '云仓发货价格：',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Obx(() => XbeanText(
                      price: controller.price.value,
                    ))
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
                child: Obx(() => ProductsGridView(
                      products: controller.products.value,
                    )))
          ])),
      Positioned(
        bottom: 100,
        left: 0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => controller.decompose(),
              child: Container(
                width: 160,
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/cardBg.png'),
                        fit: BoxFit.fill)),
                alignment: Alignment.center,
                child: const StrokeText(
                    text: '立即兑换',
                    fontSize: 14,
                    color: Colors.white,
                    strokeColor: Color.fromARGB(255, 192, 1, 1),
                    strokeWidth: 2),
              ),
            )),
      )
    ]));
  }
}

class AddressCardWidget extends StatelessWidget {
  final address;
  const AddressCardWidget({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage('assets/images/cardBg.png'), fit: BoxFit.fill),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/address.png',
                width: 50,
                height: 50,
                fit: BoxFit.fill),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      address['name'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      address['phone'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  address['detail'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class ProductsGridView extends StatelessWidget {
  final products;
  final int crossAxisCount = 4;
  final double mainAxisSpacing = 10;
  final double crossAxisSpacing = 10;
  final double childAspectRatio = 2 / 2.7;
  final Color normalTextColor = Colors.white;
  const ProductsGridView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: const EdgeInsets.only(bottom: 180),
      children: List.generate(products.length, (index) {
        var product = products[index];
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2)),
                child: Stack(
                  children: [
                    Image.network(
                      product['product_image_url'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 60,
                          height: 20,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Colors.transparent,
                            Color.fromARGB(255, 197, 1, 1),
                          ])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${product['product_level']}赏',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                product['product_name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: normalTextColor),
              ),
            ))
          ],
        );
      }),
    );
  }
}

class XbeanText extends StatelessWidget {
  final String price;
  const XbeanText({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$price仙豆',
      style: const TextStyle(
          color: Color.fromARGB(255, 211, 168, 89), fontSize: 16),
    );
  }
}
