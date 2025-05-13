import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/app_app_bar.dart';
import 'package:angelina_app/core/widgets/app_loading_indicator.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/shimmer_grid_loader.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/product_conatiner.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeeMoreProduct extends StatelessWidget {
  const SeeMoreProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => ProductCubit(ProductRepository())..fetchInitialProducts(),
        ),
        BlocProvider(create: (_) => FavoriteCubit()..loadFavorites()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    const AppAppBar(title: 'جميع المنتجات'),

                    BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoading &&
                            !(state is ProductSuccess)) {
                          return const Center(child: ShimmerGridLoader());
                        } else if (state is ProductSuccess) {
                          return Column(
                            children: [
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10.h,
                                      crossAxisSpacing: 10.w,
                                      childAspectRatio: 159 / 304,
                                    ),
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  final product = state.products[index];
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
                              if (state.hasMore)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child:
                                      state.isLoadingMore
                                          ? const Center(
                                            child: AppLoadingIndicator(),
                                          )
                                          : AppButton(
                                            btnText: 'عرض المزيد',
                                            width: 250.w,
                                            onTap: () {
                                              context
                                                  .read<ProductCubit>()
                                                  .loadMoreProducts();
                                            },
                                          ),
                                ),
                            ],
                          );
                        } else if (state is ProductFailure) {
                          return Center(child: Text('خطأ: ${state.error}'));
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
