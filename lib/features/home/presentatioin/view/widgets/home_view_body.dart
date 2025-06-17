import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/shimmer_grid_loader.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/home/manger/category_cubit/category_cubit.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/custom_categories.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/custom_home_banner.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_app_bar.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/product_conatiner.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/see_more_home.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/see_more_product.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool _isRefreshing = false; // Tracks if refresh is happening

  @override
  void initState() {
    super.initState();
  }

  // Function to handle the data refresh
  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true; // Start refresh
    });

    // Simulate network check or try loading data (mocked here)
    try {
      // Refresh data from both CategoryCubit and ProductCubit, regardless of network
      await BlocProvider.of<CategoryCubit>(context).fetchCategories();
      await BlocProvider.of<ProductCubit>(context).fetchInitialProducts();

      // If successful, update state (you can add additional logic based on connectivity)
    } catch (e) {
      // Catch network-related issues or failed attempts
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: ${e.toString()}")),
      );
    }

    setState(() {
      _isRefreshing = false; // End refresh after operation
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: RefreshIndicator(
          onRefresh:
              _refresh, // Trigger the refresh when the user pulls to refresh
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                HomeAppBar(),
                SizedBox(height: 20.h),
                CustomHomeBanner(),
                SizedBox(height: 20.h),
                SeeMoreHome(title: 'الاقسام'),
                CustomCategories(),
                SizedBox(height: 20.h),

                SeeMoreHome(
                  title: 'احدث المنتجات',
                  onTap: () => RouteUtils.push(SeeMoreProduct()),
                ),

                // Bloc to display the product list
                BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, favoriteState) {
                    return BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, productState) {
                        if (_isRefreshing) {
                          // Show shimmer loader during refresh
                          return const Center(child: ShimmerGridLoader());
                        } else if (productState is ProductSuccess) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 10.w,
                                    childAspectRatio: 159 / 304,
                                  ),
                              itemCount: productState.products.length,
                              itemBuilder: (context, index) {
                                final product = productState.products[index];
                                return ProductContainer(
                                  imageUrl:
                                      product.imageUrls.isNotEmpty
                                          ? product.imageUrls.first
                                          : '',
                                  name: product.name,
                                  category:
                                      product.categories.isNotEmpty
                                          ? product.categories.first
                                          : '',
                                  price: product.price,
                                  onTap: () {
                                    RouteUtils.push(
                                      ProductDetailsView(product: product),
                                    );
                                  },
                                  product: product,
                                );
                              },
                            ),
                          );
                        } else if (productState is ProductFailure) {
                          return Center(
                            child: Text('خطأ: ${productState.error}'),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
