import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_navigation_bar.dart';
import 'package:angelina_app/features/search/presentation/view/saerch_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: SvgPicture.asset('assets/icons/menu.svg'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      RouteUtils.push(SearchView());
                    },
                  ),
                  SizedBox(width: 5.w),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      int cartCount = 0;
                      if (cartState is CartLoaded) {
                        cartCount = cartState.items.fold(
                          0,
                          (sum, item) => sum + item.quantity,
                        );
                      }

                      return GestureDetector(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.shopping_cart),
                            if (cartCount > 0)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Text(
                                    '$cartCount',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap:
                            () => RouteUtils.puAshReplacement(
                              HomeNavigationBar(selectedIndex: 2),
                            ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Center(child: Image.asset('assets/images/logo.png', height: 50.h)),
        ],
      ),
    );
  }
}
