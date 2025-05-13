import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/core/widgets/custom_text_field.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/payment/presentation/view/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartSummarySection extends StatefulWidget {
  const CartSummarySection({super.key});

  @override
  State<CartSummarySection> createState() => _CartSummarySectionState();
}

class _CartSummarySectionState extends State<CartSummarySection> {
  final TextEditingController _discountController = TextEditingController();
  double discountPercent = 0.0;

  double calculateDiscountAmount(double total, double discountPercent) {
    return total * (discountPercent / 100);
  }

  @override
  Widget build(BuildContext context) {
    final total = context.read<CartCubit>().getTotalPrice();
    final discountAmount = calculateDiscountAmount(total, discountPercent);
    final finalTotal = total - discountAmount;

    return Container(
      height: 274.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightTextColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        color: AppColors.offWhite,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),
            CustomTextField(
              hint: 'كود الخصم',
              height: 40.h,
              borderRadius: BorderRadius.circular(9.r),
              hasUnderline: true,
              controller: _discountController,
              onChange: (value) {
                final enteredValue = double.tryParse(value) ?? 0.0;
                setState(() {
                  discountPercent = enteredValue.clamp(0.0, 100.0);
                });
              },
            ),

            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    AppText(
                      title: total.toStringAsFixed(2),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                    AppText(
                      title: 'ر.س',
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AppText(
                  title: 'سعر المنتجات',
                  fontSize: 16,
                  color: AppColors.lightTextColor,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    AppText(
                      title: discountAmount.toStringAsFixed(2),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                    AppText(
                      title: 'ر.س',
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AppText(
                  title: 'خصم',
                  fontSize: 16,
                  color: AppColors.lightTextColor,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(thickness: 2, color: AppColors.primaryColor),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    AppText(
                      title: finalTotal.toStringAsFixed(2),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                    AppText(
                      title: 'ر.س',
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AppText(
                  title: 'المجموع',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            AppButton(
              btnText: 'اتمام الطلب',
              width: double.infinity,
              height: 45.h,
              onTap: () {
                final cartCubit = context.read<CartCubit>();

                if (cartCubit.state is CartLoaded) {
                  final cartItems = (cartCubit.state as CartLoaded).items;
                  final finalTotalCents =
                      (context.read<CartCubit>().getFinalTotal() * 100).toInt();

                  // RouteUtils.push(UserInfoPage(totalPriceCents: finalTotalCents));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: context.read<CartCubit>(),
                            child: UserInfoPage(
                              totalPriceCents: finalTotalCents,
                              reorderedItems: cartItems,
                              shouldClearCart: true,
                            ),
                          ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
