import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/normal_appbar.dart';
import 'package:lzyfs_app/stroke_text.dart';
import 'package:lzyfs_app/unlogged_view.dart';

import 'my_address_page_controller.dart';

class MyAddressPage extends StatelessWidget {
  final MyAddressPageController controller = Get.put(MyAddressPageController());
  MyAddressPage({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 40,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/buttonCard.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: const Center(
                    child: StrokeText(
                      text: '我的地址',
                      fontSize: 14,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Color.fromARGB(255, 192, 1, 1),
                    ),
                  ),
                ),
                Obx(() => Visibility(
                    visible: controller.isLogged.value,
                    child: Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MyAddressesListView(controller: controller),
                          const SizedBox(height: 20),
                          AddNewAddressButton(controller: controller)
                        ],
                      ),
                    )))),
                UnloggedView(controller: controller)
              ],
            )));
  }
}

class MyAddressesListView extends StatelessWidget {
  final MyAddressPageController controller;
  const MyAddressesListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.myAddresses.length,
          itemExtent: 180,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () =>
                    controller.selectAddress(controller.myAddresses[index]),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 211, 168, 89),
                      width: 1,
                    ),
                    color: const Color.fromARGB(255, 62, 12, 11),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                controller.myAddresses[index]['name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                controller.myAddresses[index]['phone_num'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            controller.myAddresses[index]['region'],
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            controller.myAddresses[index]['detail_info'],
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: Colors.white,
                            height: 30,
                            thickness: 2,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => controller.setAddressAsDefault(
                                controller.myAddresses[index]),
                            child: const Text(
                              '设为默认',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => controller.updateAddress(
                                    controller.myAddresses[index]),
                                child: Container(
                                  width: 35,
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 211, 168, 89),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    '编辑',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () => controller.deleteAddress(
                                      controller.myAddresses[index]),
                                  child: Container(
                                    width: 35,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 211, 168, 89),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Text(
                                      '删除',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ));
          },
        ));
  }
}

class AddNewAddressButton extends StatelessWidget {
  final MyAddressPageController controller;
  const AddNewAddressButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 211, 168, 89)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            fixedSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width, 40)),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.black, width: 2))),
        onPressed: () => controller.addNewAddress(),
        child: const Text(
          '新增地址',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ));
  }
}
