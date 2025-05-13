import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHomeBanner extends StatefulWidget {
  const CustomHomeBanner({super.key});

  @override
  State<CustomHomeBanner> createState() => _CustomHomeBannerState();
}

class _CustomHomeBannerState extends State<CustomHomeBanner> {
  int _currentIndex = 0;

  final List<String> _bannerImages = [
    'assets/images/banner.png',
    'assets/images/banner2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _bannerImages.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_bannerImages[index]),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        AppText(
                          title: 'لبشره ناعمة و مشرقة',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ), // Your text
                        AppButton(
                          btnText: 'تسوق الان',
                          height: 20.h,
                          width: 60.w,
                          fontSize: 10.sp,
                          textColor: AppColors.yellow,
                        ), // Your button
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            // aspectRatio: 1,
            viewportFraction: 1,
            height: 140.h,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3), // Change interval here
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 5.h),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerImages.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              height: 5.h,
              width: 5.w,
              decoration: BoxDecoration(
                color:
                    _currentIndex == index
                        ? AppColors.primaryColor
                        : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
