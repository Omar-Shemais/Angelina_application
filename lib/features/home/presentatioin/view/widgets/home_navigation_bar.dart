import 'dart:async';

import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/Favorite/presentation/view/favourite_view.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/cart/presentation/view/cart_view.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/home_view.dart';
import 'package:angelina_app/features/profile/prensentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key, this.selectedIndex = 0});
  final int selectedIndex;

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  late int _selectedIndex;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    Future.microtask(() {
      context.read<CartCubit>().loadCart();
      context.read<FavoriteCubit>().loadFavorites();

      context.read<ProductCubit>().fetchInitialProducts().then((_) {
        context.read<ProductCubit>().checkForSales();
        context.read<ProductCubit>().checkForNewProducts();
      });
      context.read<CartCubit>().loadCart().then((_) {
        context.read<CartCubit>().checkForAbandonedCarts();
      });
      context.read<FavoriteCubit>().loadFavorites().then((_) {
        context.read<FavoriteCubit>().checkFavoriteNotifications();
      });
    });
  }

  final List<Widget> _pages = [
    const HomeView(),
    const FavouriteView(),
    CartView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, favState) {
              int cartCount = 0;
              int favCount = 0;

              if (cartState is CartLoaded) {
                cartCount = cartState.items.fold(
                  0,
                  (sum, item) => sum + item.quantity,
                );
              }

              if (favState is FavoriteLoaded) {
                favCount = favState.favorites.length;
              }

              return BottomNavigationBar(
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.purple,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        const Icon(Icons.favorite_border),
                        if (favCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                '$favCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: 'Favourite',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        if (cartCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 7,
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
                    label: 'Cart',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: AppText(title: 'Profile'));
//   }
// }
