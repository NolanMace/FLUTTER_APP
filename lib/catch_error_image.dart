import 'package:flutter/material.dart';

import 'app_config.dart';
import 'image_error.dart';

class CatchErrorImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double width;
  final double height;
  final FilterQuality filterQuality;
  const CatchErrorImage(
      {super.key,
      required this.url,
      required this.fit,
      this.width = double.infinity,
      this.height = double.infinity,
      this.filterQuality = FilterQuality.low});

  Widget buildWidget(url) {
    try {
      return Image.network(url,
          fit: fit,
          width: width,
          height: height,
          filterQuality: filterQuality,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            print('Image loading failed: $exception');
            return const ImageError(); // Custom error widget to display when image fails to load
          },
          loadingBuilder: (context, child, loadingProgress) =>
              AppConfig().lzyfLoadingWidget(context, child, loadingProgress));
    } catch (e) {
      print('enter catch exception start');
      print(e);
      print('enter catch exception end');
      return const ImageError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget(url);
  }
}
