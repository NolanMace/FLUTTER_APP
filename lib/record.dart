import 'package:flutter/material.dart';

class LotteryRecord extends StatelessWidget {
  final Map<dynamic, dynamic> record;

  //抽奖记录列表参数
  final double recordHeight = 75; //每个记录的高度
  final double recordMainSpace = 10; //两条记录之间的间隙
  final EdgeInsets recordContainerPadding =
      const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8);
  final Color recordBgColor = const Color.fromARGB(255, 53, 55, 61); //每条记录背景颜色
  final Color recordBorderColor =
      const Color.fromARGB(255, 195, 195, 195); //每条记录边框颜色
  final double recordBorderWidth = 2; //每条记录边框宽度
  final double recordBorderRadius = 10; //每条记录圆角
  final Color avatarBorderColor =
      const Color.fromARGB(255, 195, 195, 195); //头像边框颜色
  final double avatarBorderWidth = 2; //头像边框宽度
  final TextStyle nicknameStyle = const TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
  final TextStyle productNameStyle = const TextStyle(
    fontSize: 12,
    color: Colors.white,
  );
  final TextStyle dateStyle = const TextStyle(
    fontSize: 10,
    color: Colors.white,
  );
  final TextStyle productLevelStyle = const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 255, 195, 33),
      fontFamily: 'AlibabaSans',
      fontWeight: FontWeight.bold);

  const LotteryRecord({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: recordContainerPadding,
          height: recordHeight - recordMainSpace,
          decoration: BoxDecoration(
              color: recordBgColor,
              border: Border.all(
                  color: recordBorderColor, width: recordBorderWidth),
              borderRadius:
                  BorderRadius.all(Radius.circular(recordBorderRadius)),
              image: const DecorationImage(
                  image: NetworkImage(
                      'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/Asset%20100.png'),
                  fit: BoxFit.fill)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(recordHeight / 2),
                          border: Border.all(
                              color: avatarBorderColor,
                              width: avatarBorderWidth)),
                      clipBehavior: Clip.antiAlias,
                      child: ClipOval(
                        child: Image.network(
                          record['avatar_url'],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record['nickname'],
                          style: nicknameStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          record['date'],
                          style: dateStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    record['product_level_contains_number'] == true
                        ? SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25 -
                                          20,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: -3,
                                        right: 0,
                                        child: Text(
                                          '${record['product_level']}',
                                          style: productLevelStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/shang.png',
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          )
                        : Image.network(
                            'https://yfsmax.oss-cn-hangzhou.aliyuncs.com/letter/${record['product_level']}.png',
                            height: 20,
                            fit: BoxFit.fitHeight,
                          ),
                    Text(
                      record['product_name'],
                      style: productNameStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: recordMainSpace,
        )
      ],
    );
  }
}
