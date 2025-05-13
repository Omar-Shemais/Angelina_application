import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductContainer extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String category;
  final String price;
  final VoidCallback onTap;
  final ProductModel product;

  const ProductContainer({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    required this.onTap,
    required this.product,
  });

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount =
        product.salePrice.isNotEmpty &&
        product.regularPrice.isNotEmpty &&
        double.tryParse(product.regularPrice) != null &&
        double.tryParse(product.salePrice) != null &&
        double.parse(product.salePrice) < double.parse(product.regularPrice);

    double discountPercent = 0;
    if (hasDiscount) {
      final sale = double.parse(product.salePrice);
      final regular = double.parse(product.regularPrice);
      discountPercent = (((regular - sale) / regular) * 100).roundToDouble();
    }

    return Container(
      height: 304.h,
      width: 159.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        widget.imageUrl.isNotEmpty
                            ? NetworkImage(widget.imageUrl)
                            : const AssetImage(
                                  'assets/images/product_placeholder.png',
                                )
                                as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              // ⭐ Discount badge
              if (hasDiscount)
                Positioned(
                  top: 5.h,
                  right: 5.w,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 20.r,
                    child: AppText(
                      title: '-${discountPercent.toInt()}%',

                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // ❤️ Favorite Icon
              Positioned(
                top: 5.h,
                left: 5.w,
                child: CircleAvatar(
                  backgroundColor: AppColors.white.withOpacity(0.8),
                  radius: 15.r,
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      final cubit = context.read<FavoriteCubit>();
                      bool isFav = cubit.isFavorite(widget.product);
                      return GestureDetector(
                        onTap: () {
                          cubit.toggleFavorite(widget.product);
                          setState(() {});
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(
                            size: 20.sp,
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          SizedBox(
            height: 30.h,
            child: AppText(
              title: widget.name,
              fontSize: 10,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 5.h),
          AppText(
            title: widget.category,
            fontSize: 8.5,
            textAlign: TextAlign.center,
            color: AppColors.lightTextColor,
          ),
          SizedBox(height: 5.h),
          // 💰 Pricing Row
          if (hasDiscount)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection:
                      TextDirection.rtl, // this flips the row direction
                  children: [
                    AppText(
                      title: product.regularPrice,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,

                      color: AppColors.lightTextColor,
                      textDecoration: TextDecoration.lineThrough,
                    ),
                    AppText(
                      title: 'ر.س',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightTextColor,
                      textDecoration: TextDecoration.lineThrough,
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection:
                      TextDirection.rtl, // this flips the row direction
                  children: [
                    AppText(
                      title: product.salePrice,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),

                    AppText(
                      title: 'ر.س',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                AppText(
                  title: widget.price,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),

                AppText(
                  title: 'ر.س',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ],
            ),

          SizedBox(height: 5.h),
          AppButton(
            btnText: 'تحديد أحد الخيارات',
            fontSize: 9.sp,
            height: 24.h,
            width: 98.w,
            onTap: widget.onTap,
          ),
        ],
      ),
    );
  }
}
