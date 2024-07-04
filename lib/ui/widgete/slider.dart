import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/data_moudel/banner_data.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<BannerEntity> banners;
  final double borderValue;
  BannerSlider(
    this.banners, {
    super.key,
    required this.borderValue,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
            physics: defaultScrolPhisic,
            controller: _pageController,
            itemCount: banners.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: ImageLoadingService(
                borderRadius: BorderRadius.circular(12),
                imageUrl: banners[index].imageUrl,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 0,
            left: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: banners.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                    spacing: 8.0,
                    radius: 4.0,
                    dotWidth: 18.0,
                    dotHeight: 4.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey,
                    activeDotColor: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          )
        ],
      ),
    );
  }
}
