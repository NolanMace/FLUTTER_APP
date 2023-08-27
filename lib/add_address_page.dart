import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/normal_appbar.dart';

import 'add_address_page_controller.dart';

class AddAddressPage extends StatelessWidget {
  final AddAddressPageController controller =
      Get.put(AddAddressPageController());
  AddAddressPage({super.key});

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                contextMenuBuilder: (context, editableTextState) =>
                    controller.changeMenuButtonToCN(context, editableTextState),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                controller: controller.nameController,
                maxLength: 10,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person,
                        color: Colors.white, size: 20, semanticLabel: '收货人'),
                    hintText: '收货人姓名',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )),
              ),
              TextField(
                contextMenuBuilder: (context, editableTextState) =>
                    controller.changeMenuButtonToCN(context, editableTextState),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                controller: controller.phoneController,
                maxLength: 20,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                    focusColor: Colors.white,
                    prefixIcon: Icon(Icons.phone,
                        color: Colors.white, size: 20, semanticLabel: '手机号'),
                    hintText: '请输入手机号',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )),
              ),
              GestureDetector(
                  onTap: () {
                    Pickers.showAddressPicker(context,
                        addAllItem: false,
                        initProvince: controller.initProvince,
                        initCity: controller.initCity,
                        initTown: controller.initTown, onConfirm: (p, c, t) {
                      controller.onConfirmRegion(p, c, t);
                    });
                  },
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    controller: controller.regionController,
                    enabled: false,
                    decoration: const InputDecoration(
                      prefixText: '所在地区     ',
                      prefixStyle: TextStyle(color: Colors.white, fontSize: 16),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      suffixIcon:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  )),
              TextField(
                contextMenuBuilder: (context, editableTextState) =>
                    controller.changeMenuButtonToCN(context, editableTextState),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLength: 100,
                cursorColor: Colors.white,
                controller: controller.detailInfoController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home,
                        color: Colors.white, size: 20, semanticLabel: '详细地址'),
                    hintText: '请输入详细地址',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )),
              ),
              const SizedBox(height: 20),
              OnSaveButton(controller: controller),
            ])));
  }
}

class OnSaveButton extends StatelessWidget {
  final AddAddressPageController controller;
  const OnSaveButton({super.key, required this.controller});

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
        onPressed: () => controller.onSave(),
        child: const Text(
          '保存',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ));
  }
}
