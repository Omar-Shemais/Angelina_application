// // Updated version of your ReorderButton implementation that fixes the bug
// // Place this in your ReorderButton widget file

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
// import 'package:angelina_app/core/widgets/custom_text.dart';
// import 'package:angelina_app/core/widgets/snack_bar.dart';
// import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
// import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
// import 'package:angelina_app/features/home/data/repo/product_repo.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ReorderButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const ReorderButton({Key? key, required this.onPressed}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: OutlinedButton.icon(
//         icon: Icon(Icons.replay, size: 16.sp, color: AppColors.primaryColor),
//         label: const AppText(
//           title: "إعادة الطلب",
//           fontSize: 14,
//           color: AppColors.primaryColor,
//         ),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primaryColor,
//           side: BorderSide(color: AppColors.primaryColor),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         ),
//         onPressed: () => _handleReorder(context),
//       ),
//     );
//   }

//   // Helper method to check if a product is actually in the cart
//   bool _isProductInCart(CartState state, int productId) {
//     if (state is CartLoaded) {
//       return (state as CartLoaded).items.any((item) => item.id == productId);
//     }
//     return false;
//   }

//   void _handleReorder(BuildContext context) async {
//     final cartCubit = context.read<CartCubit>();
//     bool addedAny = false;

//     // Get the items from the expansion tile's order
//     final items =
//         ModalRoute.of(context)?.settings.arguments as List<dynamic>? ??
//         (context.findAncestorWidgetOfExactType<ExpansionTile>()?.trailing
//                 as List<dynamic>? ??
//             []);

//     for (final item in items) {
//       final productId = item['product_id'];

//       try {
//         final product = await ProductRepository().fetchProductById(productId);

//         // FIX: Use the current state to check if product is actually in cart
//         final currentCartState = cartCubit.state;
//         final isActuallyInCart = _isProductInCart(currentCartState, product.id);

//         if (!isActuallyInCart) {
//           await cartCubit.addToCart(product, quantity: item['quantity'] ?? 1);
//           addedAny = true;
//         }
//       } catch (e) {
//         // Handle error silently
//       }
//     }

//     if (addedAny) {
//       showSnackBar('تمت إضافة المنتجات إلى السلة');
//     } else {
//       showSnackBar('المنتجات موجودة بالفعل في السلة');
//     }
//   }
// }
