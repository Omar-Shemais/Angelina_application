import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/app_app_bar.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/core/widgets/custom_text_field.dart';
import 'package:angelina_app/core/widgets/snack_bar.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteViewBody extends StatefulWidget {
  const FavouriteViewBody({super.key});

  @override
  State<FavouriteViewBody> createState() => _FavouriteViewBodyState();
}

class _FavouriteViewBodyState extends State<FavouriteViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          AppAppBar(title: 'المفضله'),
          SizedBox(height: 20.h),
          CustomTextField(
            controller: _searchController,
            hint: 'بحث',
            onChange: (query) {
              context.read<FavoriteCubit>().searchFavorites(query);
            },
            hasUnderline: true,
          ),

          Expanded(
            child: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FavoriteLoaded) {
                  if (state.favorites.isEmpty) {
                    return const Center(child: Text('لا توجد منتجات مفضلة'));
                  }

                  return ListView.builder(
                    itemCount: state.favorites.length,
                    itemBuilder: (context, index) {
                      final product = state.favorites[index];
                      final isFavorite = context
                          .read<FavoriteCubit>()
                          .isFavorite(product);

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: InkWell(
                          onTap:
                              () => RouteUtils.push(
                                ProductDetailsView(product: product),
                              ),
                          child: Container(
                            height: 140.h,
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
                                    Container(
                                      height: double.infinity,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(15.r),
                                        ),
                                        image: DecorationImage(
                                          image:
                                              product.imageUrls.isNotEmpty
                                                  ? NetworkImage(
                                                    product.imageUrls.first,
                                                  )
                                                  : const AssetImage(
                                                        'assets/images/product_placeholder.png',
                                                      )
                                                      as ImageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5.h,
                                      right: 5.w,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.8),
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
                                            context
                                                .read<FavoriteCubit>()
                                                .toggleFavorite(product);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Product details
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 23.h,
                                      horizontal: 10.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          title: product.name,
                                          fontSize: 13,
                                          color: AppColors.boldTextColor,
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 18.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BlocBuilder<CartCubit, CartState>(
                                              builder: (context, state) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    // Check if the product is already in the cart
                                                    if (!context
                                                        .read<CartCubit>()
                                                        .isInCart(product.id)) {
                                                      context
                                                          .read<CartCubit>()
                                                          .addToCart(product);
                                                      showSnackBar(
                                                        'تمت إضافة المنتج إلى السلة',
                                                      );
                                                    } else {
                                                      // Show a message if the product is already in the cart
                                                      showSnackBar(
                                                        'المنتج موجود بالفعل في السلة',
                                                      );
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    radius: 13.r,
                                                    child: Icon(
                                                      size: 13.sp,
                                                      Icons
                                                          .shopping_cart_outlined,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            SizedBox(width: 4.w),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,

                                              textDirection: TextDirection.rtl,
                                              children: [
                                                AppText(
                                                  title: product.price,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                AppText(
                                                  title: 'ر.س',
                                                  fontSize: 13,
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('حدث خطأ ما'));
                }
              },
            ),
          ),

          // Show the "اضافه الى السله" button only when there are products
          BlocListener<FavoriteCubit, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteLoaded && state.favorites.isNotEmpty) {
                // Trigger a UI update if favorites are not empty
                setState(() {});
              }
            },
            child: Visibility(
              visible:
                  context.read<FavoriteCubit>().state is FavoriteLoaded &&
                  (context.read<FavoriteCubit>().state as FavoriteLoaded)
                      .favorites
                      .isNotEmpty,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return AppButton(
                      btnText: 'اضافه الى السله',
                      height: 45.h,
                      width: double.infinity,
                      onTap: () async {
                        final cartCubit = context.read<CartCubit>();
                        final favoriteCubit = context.read<FavoriteCubit>();

                        if (favoriteCubit.state is FavoriteLoaded) {
                          final favorites =
                              (favoriteCubit.state as FavoriteLoaded).favorites;
                          bool anyAdded = false;

                          for (var product in favorites) {
                            if (!cartCubit.isInCart(product.id)) {
                              await cartCubit.addToCart(product);
                              anyAdded = true;
                            }
                          }

                          if (anyAdded) {
                            showSnackBar(
                              'تمت إضافة المنتجات الجديدة إلى السلة',
                            );
                          } else {
                            showSnackBar('كل المنتجات موجودة بالفعل في السلة');
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
