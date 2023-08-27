import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lzyfs_app/cabinet.dart';
import 'package:lzyfs_app/cabinet_page_controller.dart';
import 'package:lzyfs_app/category_page.dart';
import 'package:lzyfs_app/exchange_ycshipment_page.dart';
import 'package:lzyfs_app/mine_index_page.dart';
import 'package:lzyfs_app/my_coupon_page.dart';
import 'package:lzyfs_app/network_controller.dart';
import 'package:lzyfs_app/yc_shipment_page.dart';
import 'add_address_page.dart';
import 'agreement_page.dart';
import 'change_box_page.dart';
import 'home_page.dart';
import 'jverify_controller.dart';
import 'mine_index_page_controller.dart';
import 'my_address_page.dart';
import 'my_consum_records_page.dart';
import 'my_shipment_page.dart';
import 'product_detail.dart';
import 'result_page.dart';
import 'use_coupon_page.dart';
import 'wxs_page.dart';
import 'yfs_jjs_page.dart';

void main() {
  runApp(GetMaterialApp(
    home: const SplashScreen(),
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/MyApp',
        page: () => const MyApp(),
      ),
      GetPage(
        name: '/yfsJjsPage',
        page: () => YfsJjjsPage(),
      ),
      GetPage(
        name: '/yfsJjsPage/productDetail',
        page: () => const ProductDetail(),
      ),
      GetPage(
        name: '/resultPage',
        page: () => ResultPage(),
      ),
      GetPage(
        name: '/wxsPage',
        page: () => WxsPage(),
      ),
      GetPage(
        name: '/wxsPage/productDetail',
        page: () => const ProductDetail(),
      ),
      GetPage(
        name: '/changeBoxPage',
        page: () => ChangeBoxPage(),
      ),
      GetPage(
        name: '/useCouponPage',
        page: () => UseCouponPage(),
      ),
      GetPage(
        name: '/myCouponPage',
        page: () => MyCouponPage(),
      ),
      GetPage(
        name: '/myAddressPage',
        page: () => MyAddressPage(),
      ),
      GetPage(
        name: '/myAddressPage/addAddress',
        page: () => AddAddressPage(),
      ),
      GetPage(
        name: '/myShipmentPage',
        page: () => MyShipmentPage(),
      ),
      GetPage(
        name: '/myConsumRecordsPage',
        page: () => MyConsumRecordsPage(),
      ),
      GetPage(
        name: '/agreementPage',
        page: () => const AgreementPage(),
      ),
      GetPage(
        name: '/ycShipmentPage',
        page: () => YcShipmentPage(),
      ),
      GetPage(
        name: '/exchangeYcshipmentPage',
        page: () => ExchangeYcshipmentPage(),
      ),
      GetPage(
        name: '/categoryPage',
        page: () => CategoryPage(),
      ),
    ],
    builder: EasyLoading.init(),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //获取版本号
  void getVersion() async {}

  String version = '1.1.1.1';

  @override
  void initState() {
    super.initState();
    // 延迟2秒后跳转到主页面
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(
        () => const MyApp(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              'assets/images/launch_image.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'v$version',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class MyAppController extends GetxController {
  int initialPage = 0;

  final PageController _pageController = PageController(initialPage: 0);
  final PageController _pageController1 = PageController(initialPage: 1);
  final PageController _pageController2 = PageController(initialPage: 2);

  PageController get pageController {
    switch (initialPage) {
      case 0:
        return _pageController;
      case 1:
        return _pageController1;
      case 2:
        return _pageController2;
      default:
        return _pageController;
    }
  }

  void changeInitiaPage(int index) {
    initialPage = index;
    if (index == 1) {
      CabinetPageController cabinetPageController = Get.find();
      cabinetPageController.refresh();
    }
    if (index == 2) {
      MineIndexPageController mineIndexPageController = Get.find();
      mineIndexPageController.getMyData();
    }
  }

  void onTabTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  final MyAppController myAppController = Get.put(MyAppController());

  void onTabTapped(int index) {
    // setState(() {
    //   _pageController.jumpToPage(index);
    // });
    myAppController.onTabTapped(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 1) {
      CabinetPageController cabinetPageController = Get.find();
      cabinetPageController.refresh();
    } else if (index == 2) {
      MineIndexPageController mineIndexPageController = Get.find();
      mineIndexPageController.getMyData();
    }
  }

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    currentIndex = myAppController.initialPage;
    final NetworkController networkController =
        Get.put(NetworkController(), permanent: true);
    final JverifyController jverifyController = Get.put(JverifyController());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 192, 1, 1),
      ),
      color: const Color.fromARGB(255, 192, 1, 1),
      title: 'lzyfs',
      home: Scaffold(
        appBar: null,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: myAppController.pageController,
          onPageChanged: onPageChanged,
          children: [
            HomePage(),
            Cabinet(),
            MineIndexPage(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: CustomBottomNavigate(
          changeIndex: onTabTapped,
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}

enum NavigateType {
  home,
  cabinet,
  myData;

  @override
  String toString() {
    switch (this) {
      case NavigateType.home:
        return '一番赏';
      case NavigateType.cabinet:
        return '赏柜';
      case NavigateType.myData:
        return '我的';
      default:
        return '一番赏';
    }
  }

  Map<String, dynamic> get iconUrl {
    switch (this) {
      case NavigateType.home:
        return {
          'selectedIconUrl': 'assets/images/tabbarYfsSelected.png',
          'iconUrl': 'assets/images/tabbarYfs.png'
        };
      case NavigateType.cabinet:
        return {
          'selectedIconUrl': 'assets/images/tabbarCabinetSelected.png',
          'iconUrl': 'assets/images/tabbarCabinet.png'
        };
      case NavigateType.myData:
        return {
          'selectedIconUrl': 'assets/images/tabbarMineSelected.png',
          'iconUrl': 'assets/images/tabbarMine.png'
        };
      default:
        return {
          'selectedIconUrl': 'assets/images/tabbarYfsSelected.png',
          'iconUrl': 'assets/images/tabbarYfs.png'
        };
    }
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
  final Color _backgroundColor = const Color.fromARGB(255, 29, 29, 31);
  final Color _backgroundColorSelected = const Color.fromARGB(255, 118, 0, 0);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 77,
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 118, 0, 0),
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: BottomAppBar(
                child: Row(
                  children: NavigateType.values
                      .map(
                        (e) => Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              widget.changeIndex(e.index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.currentIndex == e.index
                                    ? _backgroundColorSelected
                                    : _backgroundColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    widget.currentIndex == e.index
                                        ? e.iconUrl['selectedIconUrl']
                                        : e.iconUrl['iconUrl'],
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    e.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: widget.currentIndex == e.index
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 218, 1, 1)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ));
  }
}
