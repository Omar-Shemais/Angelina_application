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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ), // Smaller horizontal padding
        // Wrap the main Column with a LayoutBuilder to make it responsive
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Additional flag for extremely small screens like folds
            final isVerySmallScreen = constraints.maxHeight < 400;
            return Column(
              children: [
                // App bar and search section - fixed height components
                isVerySmallScreen
                    ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: AppText(
                        title: 'المفضله',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : AppAppBar(title: 'المفضله'),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _searchController,
                  hint: 'بحث',
                  onChange: (query) {
                    context.read<FavoriteCubit>().searchFavorites(query);
                  },
                  hasUnderline: true,
                ),
                SizedBox(height: 10.h),

                // Products list - takes remaining available space
                Expanded(
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      if (state is FavoriteLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FavoriteLoaded) {
                        if (state.favorites.isEmpty) {
                          return const Center(
                            child: Text('لا توجد منتجات مفضلة'),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.favorites.length,
                          // shrinkWrap: true,
                          // Add physics to ensure proper scrolling
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final product = state.favorites[index];
                            final isFavorite = context
                                .read<FavoriteCubit>()
                                .isFavorite(product);

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: 8.h,
                              ), // Even smaller padding for very small screens
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 500.w),
                                child: InkWell(
                                  onTap:
                                      () => RouteUtils.push(
                                        ProductDetailsView(product: product),
                                      ),
                                  child: SizedBox(
                                    // Even smaller height for very small screens
                                    height: 0.159.sh,
                                    child: Card(
                                      color: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      elevation: 2,
                                      shadowColor: Colors.grey.withOpacity(0.1),
                                      margin: EdgeInsets.zero,
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          /// 📷 Image section - fixed width approach
                                          Container(
                                            width: 156.w,
                                            // height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8.r),
                                                bottomRight: Radius.circular(
                                                  8.r,
                                                ),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                              8.r,
                                                            ),
                                                        bottomRight:
                                                            Radius.circular(
                                                              8.r,
                                                            ),
                                                      ),
                                                  child: Image(
                                                    image:
                                                        product
                                                                .imageUrls
                                                                .isNotEmpty
                                                            ? NetworkImage(
                                                              product
                                                                  .imageUrls
                                                                  .first,
                                                            )
                                                            : const AssetImage(
                                                                  'assets/images/product_placeholder.png',
                                                                )
                                                                as ImageProvider,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4.h,
                                                  right: 4.w,
                                                  child: Container(
                                                    width: 20.w,
                                                    height: 20.w,
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
                                                          context
                                                              .read<
                                                                FavoriteCubit
                                                              >()
                                                              .toggleFavorite(
                                                                product,
                                                              );
                                                          setState(() {});
                                                        },
                                                        child: Icon(
                                                          isFavorite
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          size: 15.sp,
                                                          color:
                                                              AppColors
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// 📝 Product info
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 20.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    title: product.name,
                                                    fontSize: 13,
                                                    color:
                                                        AppColors.boldTextColor,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.right,
                                                  ),

                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        title:
                                                            '${product.price} ر.س',
                                                        fontSize: 13,
                                                        textDirection:
                                                            TextDirection.rtl,

                                                        color:
                                                            AppColors
                                                                .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (!context
                                                              .read<CartCubit>()
                                                              .isInCart(
                                                                product.id,
                                                              )) {
                                                            context
                                                                .read<
                                                                  CartCubit
                                                                >()
                                                                .addToCart(
                                                                  product,
                                                                );
                                                            showSnackBar(
                                                              'تمت إضافة المنتج إلى السلة',
                                                            );
                                                          } else {
                                                            showSnackBar(
                                                              'المنتج موجود بالفعل في السلة',
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 20.w,
                                                          height: 20.w,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                AppColors
                                                                    .primaryColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors
                                                                        .black12,
                                                                blurRadius: 2.r,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .shopping_cart_outlined,
                                                              size: 12.sp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
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

                // Bottom button - fixed height element with conditional visibility
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

                            onTap: () async {
                              final cartCubit = context.read<CartCubit>();
                              final favoriteCubit =
                                  context.read<FavoriteCubit>();

                              if (favoriteCubit.state is FavoriteLoaded) {
                                final favorites =
                                    (favoriteCubit.state as FavoriteLoaded)
                                        .favorites;
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
                                  showSnackBar(
                                    'كل المنتجات موجودة بالفعل في السلة',
                                  );
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
            );
          },
        ),
      ),
    );
  }
}
