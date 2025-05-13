import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistroyProudctTitle extends StatelessWidget {
  final ProductModel product;

  final dynamic item;
  const HistroyProudctTitle({super.key, required this.product, this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouteUtils.push(ProductDetailsView(product: product)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image:
                      product.imageUrls.isNotEmpty
                          ? NetworkImage(product.imageUrls.first)
                          : const AssetImage(
                                'assets/images/product_placeholder.png',
                              )
                              as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title: product.name,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.boldTextColor,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: AppText(
                          title: 'الكمية: ${item['quantity']}',
                          fontSize: 12,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: [
                          AppText(
                            title: product.price,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                          AppText(
                            title: 'ر.س ',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon for details
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
