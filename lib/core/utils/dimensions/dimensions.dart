import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class Dimensions {
  /// Returns fractional height of screen minus AppBar if specified
  static double getHeight(
    BuildContext context,
    int fraction, {
    bool removeAppBarHeight = true,
  }) {
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    if (removeAppBarHeight) {
      height -= AppBar().preferredSize.height + mediaQuery.padding.top;
    }
    return height / fraction;
  }

  /// Returns fractional width of screen
  static double getWidth(BuildContext context, int fraction) {
    return MediaQuery.of(context).size.width / fraction;
  }

  /// Responsive scaling factor based on screen width
  static double scaleFactor(BuildContext context, [double baseWidth = 375]) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scale = screenWidth / baseWidth;
    return min(scale, 1.2); // Cap it for large screens
  }
}

extension DimensionsExtension on num {
  /// Responsive height
  double get height => h;

  /// Responsive width
  double get width => w;

  /// Responsive radius (with capping)
  double get radius {
    final capped = min(toDouble(), 20.0);
    return capped.r;
  }

  /// Responsive font size (with cap)
  double rsp(BuildContext context) {
    double scale = Dimensions.scaleFactor(context);
    return toDouble() * scale.sp;
  }
}

// class Dimensions {
//   static double getHeight(
//     context,
//     int fraction, {
//     bool removeAppBarHeight = true,
//   }) {
//     final mediaQuery = MediaQuery.of(context);
//     if (removeAppBarHeight) {
//       return (mediaQuery.size.height -
//               AppBar().preferredSize.height -
//               mediaQuery.padding.top) /
//           fraction;
//     }
//     return mediaQuery.size.height / fraction;
//   }

//   static double getWidth(context, int fraction) {
//     return MediaQuery.of(context).size.width / fraction;
//   }
// }

// extension DimensionsExtension on num {
//   double get height {
//     return h;
//   }

//   double get width {
//     return w;
//   }
// }
/*
IntrinsicHeight(
                                child: InkWell(
                                  onTap:
                                      () => RouteUtils.push(
                                        ProductDetailsView(product: product),
                                      ),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        /// 📷 Image (flex 5)
                                        Flexible(
                                          flex:
                                              4, // Increased from 4 to 5 to make image take more space
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                    8.r,
                                                  ),
                                                  bottomRight: Radius.circular(
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
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 6.h,
                                                right: 6.w,
                                                child: Container(
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
                                                        size: 16.sp,
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

                                        /// 📄 Info (flex 5 or 4 depending on spacing)
                                        Flexible(
                                          flex: 6,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 8.h,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  title: product.name,
                                                  fontSize: 13.sp,
                                                  color:
                                                      AppColors.boldTextColor,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.right,
                                                ),
                                                Row(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  children: [
                                                    AppText(
                                                      title:
                                                          '${product.price} ر.س',
                                                      fontSize: 13.sp,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (!context
                                                            .read<CartCubit>()
                                                            .isInCart(
                                                              product.id,
                                                            )) {
                                                          context
                                                              .read<CartCubit>()
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
                                                        width: 28.w,
                                                        height: 28.w,
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
                                                              blurRadius: 4.r,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .shopping_cart_outlined,
                                                            size: 16.sp,
                                                            color: Colors.white,
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
                              );
*/
