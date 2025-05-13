import 'package:angelina_app/core/widgets/app_app_bar.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/cart/presentation/view/widgets/cart_item.dart';
import 'package:angelina_app/features/cart/presentation/view/widgets/cart_summaery_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          final cartItems = state.items;

          if (cartItems.isEmpty) {
            return const Center(child: Text('لا توجد منتجات في السلة'));
          }

          return Column(
            children: [
              SizedBox(height: 40.h),
              AppAppBar(title: 'عربه التسوق'),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(itemIndex: index);
                  },
                ),
              ),
              CartSummarySection(),
            ],
          );
        } else if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('حدث خطأ ما في تحميل السلة'));
        }
      },
    );
  }
}
