import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/search/presentation/view/widgets/search_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(title: 'بحث', fontSize: 22, fontWeight: FontWeight.w500),
        centerTitle: true,

        backgroundColor: AppColors.white,

        elevation: 0,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    ProductCubit(ProductRepository())..fetchInitialProducts(),
          ),
          BlocProvider(create: (context) => FavoriteCubit()..loadFavorites()),
        ],
        child: SearchViewBody(),
      ),
    );
  }
}
