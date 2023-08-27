import 'package:flutter/material.dart';

class PopUpBackground extends StatelessWidget {
  final Widget child;
  const PopUpBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Stack(children: [
        Column(children: [
          const SizedBox(
            height: 25,
          ),
          Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 53, 55, 61),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border.all(
                      color: const Color.fromARGB(255, 197, 1, 1),
                      width: 4,
                      style: BorderStyle.solid)),
              child: child),
        ]),
        Positioned(
            top: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 30,
                    height: 30,
                  ),
                  Image.asset(
                    'assets/images/confirmOrder.png',
                    width: 160,
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/images/cancel.png',
                      width: 30,
                      height: 30,
                    ),
                  )
                ],
              ),
            ))
      ])
    ]);
  }
}
