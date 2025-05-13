import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsImag extends StatefulWidget {
  const ProductDetailsImag({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsImag> createState() => _ProductDetailsImagState();
}

class _ProductDetailsImagState extends State<ProductDetailsImag> {
  late String selectedImage;
  int currentStartIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedImage =
        widget.product.imageUrls.isNotEmpty
            ? widget.product.imageUrls.first
            : '';
  }

  void _scrollUp() {
    setState(() {
      if (currentStartIndex > 0) {
        currentStartIndex -= 1;
      }
    });
  }

  void _scrollDown() {
    setState(() {
      if (currentStartIndex + 3 < widget.product.imageUrls.length) {
        currentStartIndex += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:
              widget.product.imageUrls.isNotEmpty
                  ? Image.network(
                    selectedImage,
                    width: double.infinity,
                    height: 395.h,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 100),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 395.h,
                          color: Colors.white,
                        ),
                      );
                    },
                  )
                  : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 395.h,
                      color: Colors.white,
                    ),
                  ),
        ),
        Positioned(
          top: 15.h,
          left: 15.w,
          child: GestureDetector(
            onTap: () {
              RouteUtils.pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 30.sp),
          ),
        ),
        Positioned(
          top: 15.h,
          right: 10.w,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.8),
            child: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                bool isFav = context.read<FavoriteCubit>().isFavorite(
                  widget.product,
                );
                return GestureDetector(
                  onTap: () {
                    context.read<FavoriteCubit>().toggleFavorite(
                      widget.product,
                    );
                    setState(() {});
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        Positioned(
          left: 30,
          top: 50,
          child: Column(
            children: [
              // UP Arrow
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up),
                onPressed: _scrollUp,
                color: AppColors.primaryColor,
              ),

              // 3 Small Images Fixed
              Column(
                children: List.generate(3, (index) {
                  int imageIndex = currentStartIndex + index;
                  if (imageIndex >= widget.product.imageUrls.length) {
                    return const SizedBox();
                  }
                  String imageUrl = widget.product.imageUrls[imageIndex];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = imageUrl;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              selectedImage == imageUrl
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 90,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                onPressed: _scrollDown,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
