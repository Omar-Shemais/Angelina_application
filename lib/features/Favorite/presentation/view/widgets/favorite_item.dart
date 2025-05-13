// import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
// import 'package:angelina_app/core/widgets/custom_text.dart';
// import 'package:angelina_app/core/widgets/snack_bar.dart';
// import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
// import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
// import 'package:angelina_app/features/home/data/model/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class FavoriteItem extends StatefulWidget {
//   final ProductModel product;
//   final bool isFavorite;

//   const FavoriteItem({
//     super.key,
//     required this.product,
//     required this.isFavorite,
//   });

//   @override
//   State<FavoriteItem> createState() => _FavoriteItemState();
// }

// class _FavoriteItemState extends State<FavoriteItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: Container(
//         height: 140.h,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.white),
//           borderRadius: BorderRadius.circular(8.r),
//           color: AppColors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           textDirection: TextDirection.rtl,
//           children: [
//             _buildImageSection(context),
//             _buildDetailsSection(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImageSection(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: double.infinity,
//           width: 150.w,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.horizontal(right: Radius.circular(15.r)),
//             image: DecorationImage(
//               image:
//                   widget.product.imageUrls.isNotEmpty
//                       ? NetworkImage(widget.product.imageUrls.first)
//                       : const AssetImage(
//                             'assets/images/product_placeholder.png',
//                           )
//                           as ImageProvider,
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 5.h,
//           right: 5.w,
//           child: CircleAvatar(
//             backgroundColor: Colors.white.withOpacity(0.8),
//             radius: 15.r,
//             child: IconButton(
//               padding: EdgeInsets.zero,
//               icon: Icon(
//                 widget.isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: AppColors.primaryColor,
//                 size: 18.sp,
//               ),
//               onPressed: () {
//                 context.read<FavoriteCubit>().toggleFavorite(widget.product);
//                 setState(() {});
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailsSection(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 23.h, horizontal: 10.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AppText(
//               title: widget.product.name,
//               fontSize: 13,
//               color: AppColors.boldTextColor,
//               textAlign: TextAlign.right,
//             ),
//             SizedBox(height: 18.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildAddToCartButton(context),
//                 SizedBox(width: 4.w),
//                 AppText(
//                   title: '${widget.product.price} ر.س',
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddToCartButton(BuildContext context) {
//     return BlocBuilder<CartCubit, dynamic>(
//       builder: (context, state) {
//         return GestureDetector(
//           onTap: () {
//             final cartCubit = context.read<CartCubit>();
//             if (!cartCubit.isInCart(widget.product.id)) {
//               cartCubit.addToCart(widget.product);
//               showSnackBar('تمت إضافة المنتج إلى السلة');
//             } else {
//               showSnackBar('المنتج موجود بالفعل في السلة');
//             }
//           },
//           child: CircleAvatar(
//             backgroundColor: AppColors.primaryColor,
//             radius: 13.r,
//             child: Icon(
//               Icons.shopping_cart_outlined,
//               color: AppColors.white,
//               size: 13.sp,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
