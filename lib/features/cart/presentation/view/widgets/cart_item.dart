import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/cart/presentation/view/widgets/cart_counter.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatefulWidget {
  final int itemIndex;

  const CartItemWidget({super.key, required this.itemIndex});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    // final favoriteCubit = context.read<FavoriteCubit>();
    final item = (cartCubit.state as CartLoaded).items[widget.itemIndex];

    final productModel = ProductModel(
      id: item.id,
      name: item.name,
      price: item.price,
      imageUrls: item.imageUrls,
      description: item.name,
      categories: [],
      categoryIds: [],
      attributes: [],
      colors: [],
      regularPrice: '',
      salePrice: '',
      dateCreated: '',
      onSale: false,
      stockQuantity: 100,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, right: 20.w, left: 20.w),
      child: Stack(
        children: [
          Container(
            // height: 140.h,
            height: 0.16.sh,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white),
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap:
                          () => RouteUtils.push(
                            ProductDetailsView(product: productModel),
                          ),
                      child: Container(
                        height: double.infinity,
                        width: 150.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15.r),
                          ),
                          image: DecorationImage(
                            image:
                                item.imageUrls.isNotEmpty
                                    ? NetworkImage(item.imageUrls.first)
                                    : const AssetImage(
                                          'assets/images/product_placeholder.png',
                                        )
                                        as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          final isFavorite = context
                              .read<FavoriteCubit>()
                              .isFavorite(productModel);
                          return Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2.r,
                                ),
                              ],
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<FavoriteCubit>().toggleFavorite(
                                    productModel,
                                  );
                                  setState(() {});
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.primaryColor,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    /*
                     Positioned(
                      top: 5.h,
                      right: 5.w,
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, favState) {
                          final isFavorite = context
                              .read<FavoriteCubit>()
                              .isFavorite(productModel);
                          return CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            radius: 15.r,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColors.primaryColor,
                                size: 18.sp,
                              ),
                              onPressed: () {
                                context.read<FavoriteCubit>().toggleFavorite(
                                  productModel,
                                );
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    */
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 10.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          title: item.name,
                          fontSize: 13,
                          color: AppColors.boldTextColor,
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 4.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.rtl,
                              children: [
                                AppText(
                                  title: (double.parse(item.price) *
                                          item.quantity)
                                      .toStringAsFixed(2),
                                  fontSize: 13.6,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                                AppText(
                                  title: 'ر.س',
                                  fontSize: 13.6,
                                  color: AppColors.primaryColor,

                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            QuantitySelector(item: item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -7.5.h,
            left: -7.5.w,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              radius: 15.r,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close, size: 18.sp),
                onPressed: () {
                  context.read<CartCubit>().removeFromCart(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
