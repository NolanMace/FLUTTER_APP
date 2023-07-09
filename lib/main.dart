import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/cabinet.dart';
import 'package:lzyfs_app/cabinet_page_controller.dart';
import 'package:lzyfs_app/my_data.dart';
import 'package:lzyfs_app/network_controller.dart';
import 'home_page.dart';
import 'jverify_controller.dart';

void main() {
  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final PageController _pageController = PageController();

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      if (index == 1) {
        CabinetPageController cabinetPageController = Get.find();
        cabinetPageController.getMyProducts();
      }
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    final NetworkController networkController =
        Get.put(NetworkController(), permanent: true);
    final JverifyController jverifyController = Get.put(JverifyController());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'lzyfs',
        home: Scaffold(
          appBar: null,
          body: PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: [
              HomePage(),
              Cabinet(),
              MyData(),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: CustomBottomNavigate(
            changeIndex: onTabTapped,
            currentIndex: currentIndex,
          ),
        ));
  }
}

class CustomBottomNavigate extends StatefulWidget {
  final Function changeIndex;
  final int currentIndex;
  const CustomBottomNavigate(
      {super.key, required this.changeIndex, required this.currentIndex});

  @override
  State<CustomBottomNavigate> createState() => _CustomBottomNavigateState();
}

class _CustomBottomNavigateState extends State<CustomBottomNavigate> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Theme(
                      data: ThemeData(
                        brightness: Brightness.light,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: BottomNavigationBar(
                        selectedFontSize: 1,
                        unselectedFontSize: 1,
                        type: BottomNavigationBarType.fixed,
                        elevation: 0,
                        enableFeedback: false,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        backgroundColor: Colors.transparent,
                        currentIndex: widget.currentIndex,
                        onTap: (int index) {
                          widget.changeIndex(index);
                        },
                        items: [
                          BottomNavigationBarItem(
                              icon: Center(
                                child: Image.network(
                                  'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/btnyfs.png',
                                  width: widget.currentIndex == 0 ? 60 : 50,
                                  height: widget.currentIndex == 0 ? 60 : 50,
                                ),
                              ), // 自定义图片图标
                              label: ''),
                          BottomNavigationBarItem(
                              icon: Center(
                                child: Image.network(
                                  'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/btncabinet.png',
                                  width: widget.currentIndex == 1 ? 60 : 50,
                                  height: widget.currentIndex == 1 ? 60 : 50,
                                ),
                              ),
                              label: ''),
                          BottomNavigationBarItem(
                              icon: Center(
                                child: Image.network(
                                  'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/btnmydata.png',
                                  width: widget.currentIndex == 2 ? 60 : 50,
                                  height: widget.currentIndex == 2 ? 60 : 50,
                                ),
                              ),
                              label: ''),
                        ],
                      )),
                ))
          ],
        ));
  }
}
