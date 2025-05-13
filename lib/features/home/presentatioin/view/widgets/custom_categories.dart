import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/core/widgets/shimmer_categories_loader.dart';
import 'package:angelina_app/features/home/manger/category_cubit/category_cubit.dart';
import 'package:angelina_app/features/home/manger/category_cubit/category_state.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/product_category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCategories extends StatelessWidget {
  const CustomCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: ShimmerCategoriesLoader());
        } else if (state is CategorySuccess) {
          return SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: state.categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        RouteUtils.push(
                          ProductCategoryView(
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                        );
                      },
                      child: Container(
                        height: 70.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/category_placeholder.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    AppText(title: category.name, fontSize: 12),
                  ],
                );
              },
            ),
          );
        } else if (state is CategoryFailure) {
          return Center(child: Text('خطأ: ${state.error}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
