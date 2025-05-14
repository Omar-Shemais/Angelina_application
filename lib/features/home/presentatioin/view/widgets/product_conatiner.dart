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

    return InkWell(
      onTap: widget.onTap,
      child: IntrinsicHeight(
        child: Card(
          color: AppColors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300), // optional border
          ),
          child: Container(
            width: 159.w,
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 5.h,
                      left: 5.w,
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          final cubit = context.read<FavoriteCubit>();
                          final isFav = cubit.isFavorite(widget.product);
                          return Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4.r,
                                ),
                              ],
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  cubit.toggleFavorite(product);
                                  setState(() {});
                                },
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                AppText(
                  title: widget.name,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                AppText(
                  title: widget.category,
                  fontSize: 10,
                  textAlign: TextAlign.center,
                  color: AppColors.lightTextColor,
                ),
                SizedBox(height: 5.h),

                /// Pricing
                hasDiscount
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            AppText(
                              title: product.regularPrice,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightTextColor,
                              textDecoration: TextDecoration.lineThrough,
                            ),
                            AppText(
                              title: 'ر.س',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightTextColor,
                              textDecoration: TextDecoration.lineThrough,
                            ),
                          ],
                        ),
                        SizedBox(width: 5.w),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            AppText(
                              title: product.salePrice,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            AppText(
                              title: 'ر.س',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        AppText(
                          title: widget.price,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                        AppText(
                          title: 'ر.س',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),

                SizedBox(height: 5.h),
                AppButton(
                  btnText: 'تحديد أحد الخيارات',
                  fontSize: 9,
                  width: 98.w,
                  height: 28.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
