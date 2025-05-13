import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatelessWidget {
  final dynamic item;

  const QuantitySelector({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Container(
      height: 20.h,
      width: 53.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              cartCubit.decreaseQuantity(item.id);
            },
            child: Icon(
              Icons.remove,
              color: AppColors.primaryColor,
              size: 10.5,
            ),
          ),
          AppText(
            title: item.quantity.toString(),
            color: AppColors.boldTextColor,
            fontSize: 10.5,
          ),
          GestureDetector(
            onTap: () {
              cartCubit.increaseQuantity(item.id);
            },
            child: Icon(Icons.add, color: AppColors.primaryColor, size: 10.5),
          ),
        ],
      ),
    );
  }
}
