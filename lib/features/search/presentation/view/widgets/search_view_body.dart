import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/core/widgets/custom_text_field.dart';
import 'package:angelina_app/core/widgets/shimmer_grid_loader.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/product_conatiner.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

String query = '';

class _SearchViewBodyState extends State<SearchViewBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // SizedBox(height: 40.h),
              // AppAppBar(title: 'بحث'),
              SizedBox(height: 20.h),
              CustomTextField(
                hint: 'ابحث عن منتج...',
                prefixIcon: Icon(Icons.search),
                onChange: (value) {
                  query = value;
                  context.read<ProductCubit>().searchProducts(query);
                },
                hasUnderline: true,
              ),
              SizedBox(height: 20.h),

              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductSuccess) {
                    final filteredProducts =
                        state.products.where((product) {
                          return product.name.toLowerCase().contains(query);
                        }).toList();

                    if (query.isEmpty) {
                      return const Center(
                        child: AppText(title: 'أدخل كلمة للبحث عن منتج'),
                      );
                    }

                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: AppText(title: 'لا يوجد منتجات بهذا الاسم'),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 159 / 304,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
                  } else if (state is ProductLoading) {
                    return const Center(child: ShimmerGridLoader());
                  } else {
                    return const Center(
                      child: AppText(title: 'فشل في تحميل المنتجات'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
